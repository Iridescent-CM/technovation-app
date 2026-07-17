import { createRequire } from "module";
import fs from "fs";
import os from "os";
import path from "path";
import { afterEach, describe, expect, it } from "vitest";

const require = createRequire(import.meta.url);
const { extractBundles } = require("../../../perf/scripts/extract-bundles.js");

const FIXTURE_STATS = {
  entrypoints: {
    application: {
      assets: [
        { name: "packs/application.js" },
        { name: "packs/vendors-abc123.js" },
      ],
    },
    application_rebrand: {
      assets: [{ name: "packs/application_rebrand.css" }],
    },
    judge: {
      assets: [{ name: "packs/judge.js" }, { name: "packs/vendors-abc123.js" }],
    },
    admin: {
      assets: [{ name: "packs/admin.js" }, { name: "packs/vendors-abc123.js" }],
    },
    new_registration: {
      assets: [{ name: "packs/new_registration.js" }],
    },
    submissions: {
      assets: [{ name: "packs/submissions.js" }],
    },
  },
  assets: [
    { name: "packs/application.js", size: 10240 },
    { name: "packs/vendors-abc123.js", size: 51200 },
    { name: "packs/judge.js", size: 8192 },
    { name: "packs/admin.js", size: 6144 },
    { name: "packs/application_rebrand.css", size: 4096 },
    { name: "packs/new_registration.js", size: 20480 },
    { name: "packs/submissions.js", size: 16384 },
  ],
};

describe("extract-bundles", () => {
  let tempDir;

  afterEach(() => {
    if (tempDir) {
      fs.rmSync(tempDir, { recursive: true, force: true });
      tempDir = null;
    }
  });

  function writeAsset(name, content) {
    const filePath = path.join(tempDir, name);
    fs.mkdirSync(path.dirname(filePath), { recursive: true });
    fs.writeFileSync(filePath, content);
  }

  function runExtract() {
    return extractBundles(FIXTURE_STATS, {
      outputDir: tempDir,
      statsFile: "fixture-stats.json",
    });
  }

  it("preserves packs_kb for tracked entry packs", () => {
    tempDir = fs.mkdtempSync(path.join(os.tmpdir(), "extract-bundles-"));
    writeAsset("application.js", "application pack");

    const output = runExtract();

    expect(output.packs_kb.application).toBe(10);
    expect(output.packs_kb.judge).toBe(8);
    expect(output.packs_kb.admin).toBe(6);
  });

  it("attributes vendor chunks to layouts via entrypoint asset unions", () => {
    tempDir = fs.mkdtempSync(path.join(os.tmpdir(), "extract-bundles-"));
    writeAsset("application.js", "application pack");
    writeAsset("vendors-abc123.js", "shared vendor chunk");
    writeAsset("judge.js", "judge pack");
    writeAsset("application_rebrand.css", "rebrand styles");

    const output = runExtract();
    const judge = output.layouts.judge;

    expect(judge.packs).toEqual([
      "application",
      "application_rebrand",
      "judge",
    ]);
    expect(judge.total_kb).toBe(72);
    expect(judge.js_kb).toBe(68);
    expect(judge.css_kb).toBe(4);
    expect(judge.chunk_count).toBe(4);
  });

  it("counts shared vendor chunks once per layout", () => {
    tempDir = fs.mkdtempSync(path.join(os.tmpdir(), "extract-bundles-"));
    writeAsset("application.js", "application pack");
    writeAsset("vendors-abc123.js", "shared vendor chunk");
    writeAsset("admin.js", "admin pack");

    const output = runExtract();

    expect(output.layouts.application.total_kb).toBe(60);
    expect(output.layouts.admin.total_kb).toBe(66);
  });

  it("reports gzip transferred sizes smaller than raw sizes", () => {
    tempDir = fs.mkdtempSync(path.join(os.tmpdir(), "extract-bundles-"));
    const repeated = "console.log('bundle optimization measurement');\n".repeat(
      200
    );
    writeAsset("application.js", repeated);
    writeAsset("vendors-abc123.js", repeated);

    const output = runExtract();
    const application = output.layouts.application;

    expect(application.total_gzip_kb).toBeGreaterThan(0);
    expect(application.total_gzip_kb).toBeLessThan(application.total_kb);
    expect(application.js_gzip_kb).toBeLessThan(application.js_kb);
  });

  it("resolves gzip sizes from public/packs/js and css subdirectories", () => {
    tempDir = fs.mkdtempSync(path.join(os.tmpdir(), "extract-bundles-"));
    const repeated = "console.log('bundle optimization measurement');\n".repeat(
      200
    );
    writeAsset("js/application.js", repeated);
    writeAsset("js/vendors-abc123.js", repeated);

    const output = runExtract();
    const application = output.layouts.application;

    expect(application.total_gzip_kb).toBeGreaterThan(0);
    expect(application.total_gzip_kb).toBeLessThan(application.total_kb);
  });

  it("writes bundles.json when outputPath is provided", () => {
    tempDir = fs.mkdtempSync(path.join(os.tmpdir(), "extract-bundles-"));
    const outPath = path.join(tempDir, "bundles.json");
    writeAsset("application.js", "application pack");

    extractBundles(FIXTURE_STATS, {
      outputPath: outPath,
      outputDir: tempDir,
      statsFile: "fixture-stats.json",
    });

    const written = JSON.parse(fs.readFileSync(outPath, "utf8"));
    expect(written.layouts.application).toBeDefined();
    expect(written.packs_kb).toBeDefined();
  });
});
