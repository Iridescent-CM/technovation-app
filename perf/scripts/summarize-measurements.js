#!/usr/bin/env node
"use strict"

const fs = require("fs")
const path = require("path")

const PHASE1_ROLES = ["public", "mentor", "judge", "admin"]

const localDir = process.argv[2] || "perf/baselines/2026-06-25-b65adb9da-local-prod"
const qaDir = process.argv[3] || "perf/baselines/2026-06-25-b65adb9da-qa"
const outPath = process.argv[4] || "perf/baselines/2026-06-25-b65adb9da-measurements.json"

const DIAGNOSTIC_AUDITS = [
  "server-response-time",
  "total-byte-weight",
  "duplicated-javascript",
  "unused-javascript",
  "render-blocking-resources",
  "bootup-time",
  "mainthread-work-breakdown"
]

const report = {
  generated_at: new Date().toISOString(),
  phase1_roles: PHASE1_ROLES,
  note: "Compare local before/after and QA before/after separately — not local absolutes vs QA.",
  local: summarizeEnv(localDir, "tmp/lhci/2026-06-25-b65adb9da-local-prod"),
  qa: summarizeEnv(qaDir, "tmp/lhci/2026-06-25-b65adb9da-qa"),
  bundles_kb: readBundles(path.join(localDir, "bundles.json"))
}

fs.mkdirSync(path.dirname(outPath), { recursive: true })
fs.writeFileSync(outPath, JSON.stringify(report, null, 2) + "\n")

printReport(report)
console.log(`\nsummarize-measurements: wrote ${outPath}`)

function summarizeEnv(baselineDir, lhciRoot) {
  const env = { baseline_dir: baselineDir, roles: {} }

  for (const role of PHASE1_ROLES) {
    const file = path.join(baselineDir, `${role}.json`)
    if (!fs.existsSync(file)) {
      env.roles[role] = { missing: true }
      continue
    }

    const baseline = JSON.parse(fs.readFileSync(file, "utf8"))
    const pages = {}

    for (const [pagePath, metrics] of Object.entries(baseline.pages || {})) {
      pages[pagePath] = {
        lcp_median_ms: metrics.lcp_median_ms,
        tbt_median_ms: metrics.tbt_median_ms,
        cls_median: metrics.cls_median,
        score_median: metrics.score_median,
        final_urls: metrics.final_urls,
        diagnostics: diagnosticsFromLhci(lhciRoot, role, pagePath, baseline.base_url)
      }
    }

    env.roles[role] = {
      environment: baseline.environment,
      base_url: baseline.base_url,
      captured_at: baseline.captured_at,
      pages
    }
  }

  return env
}

function diagnosticsFromLhci(lhciRoot, role, pagePath, baseUrl) {
  const manifestPath = path.join(lhciRoot, role, "manifest.json")
  if (!fs.existsSync(manifestPath)) return null

  const manifest = JSON.parse(fs.readFileSync(manifestPath, "utf8"))
  const entry =
    manifest.find((row) => row.isRepresentativeRun) ||
    manifest.find((row) => pathnameFromUrl(row.url) === pagePath) ||
    manifest[0]

  if (!entry?.jsonPath || !fs.existsSync(entry.jsonPath)) return null

  const lhr = JSON.parse(fs.readFileSync(entry.jsonPath, "utf8"))
  const out = { representative_run: path.basename(entry.jsonPath) }

  for (const auditId of DIAGNOSTIC_AUDITS) {
    const audit = lhr.audits?.[auditId]
    if (!audit) continue

    out[auditId] = {
      score: audit.score,
      numeric_value: audit.numericValue ?? null,
      display: audit.displayValue ?? null,
      wasted_kb: wastedKb(audit)
    }
  }

  return out
}

function wastedKb(audit) {
  const items = audit.details?.items
  if (!Array.isArray(items)) return null

  let bytes = 0
  for (const item of items) {
    bytes += item.wastedBytes || item.totalBytes || 0
  }
  return bytes ? round1(bytes / 1024) : null
}

function readBundles(file) {
  if (!fs.existsSync(file)) return null
  return JSON.parse(fs.readFileSync(file, "utf8")).packs_kb || null
}

function printReport(report) {
  console.log("=== Phase 1 measurements (no cross-env score comparison) ===\n")

  if (report.bundles_kb) {
    console.log("[bundles KB @ local prod build]")
    for (const [pack, kb] of Object.entries(report.bundles_kb).sort()) {
      console.log(`  ${pack}: ${kb}`)
    }
    console.log("")
  }

  for (const envName of ["local", "qa"]) {
    console.log(`--- ${envName.toUpperCase()} (${report[envName].baseline_dir}) ---`)
    for (const role of PHASE1_ROLES) {
      const roleData = report[envName].roles[role]
      if (!roleData || roleData.missing) {
        console.log(`[${role}] missing`)
        continue
      }

      for (const [pagePath, page] of Object.entries(roleData.pages)) {
        console.log(
          `[${role}] ${pagePath}: LCP ${page.lcp_median_ms}ms score ${page.score_median} TBT ${page.tbt_median_ms}ms CLS ${page.cls_median}`
        )
        if (page.final_urls?.length) {
          console.log(`  final: ${page.final_urls.join(", ")}`)
        }
        if (page.diagnostics) {
          const d = page.diagnostics
          const highlights = [
            d["server-response-time"]?.display,
            d["total-byte-weight"]?.display,
            d["unused-javascript"]?.display,
            d["duplicated-javascript"]?.display,
            d["render-blocking-resources"]?.display
          ].filter(Boolean)
          if (highlights.length) {
            console.log(`  LH: ${highlights.join(" | ")}`)
          }
        }
      }
    }
    console.log("")
  }
}

function pathnameFromUrl(url) {
  return new URL(url).pathname
}

function round1(n) {
  return Math.round(n * 10) / 10
}
