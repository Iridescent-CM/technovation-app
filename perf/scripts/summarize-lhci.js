#!/usr/bin/env node
"use strict"

const fs = require("fs")
const path = require("path")

const lhciDir = process.argv[2]
const role = process.argv[3]
const outputPath = process.argv[4]

const meta = {
  environment: process.env.PERF_ENVIRONMENT || "local",
  sha: process.env.PERF_BASELINE_SHA || null,
  base_url: process.env.PERF_BASE_URL || "http://localhost:3000",
  role,
  runs: 5,
  captured_at: new Date().toISOString(),
  lhci_output_dir: lhciDir
}

if (!lhciDir || !role || !outputPath) {
  console.error("usage: summarize-lhci.js <lhci-dir> <role> <output.json>")
  process.exit(1)
}

const manifestPath = path.join(lhciDir, "manifest.json")
if (!fs.existsSync(manifestPath)) {
  console.error(`summarize-lhci: missing ${manifestPath}`)
  process.exit(1)
}

const manifest = JSON.parse(fs.readFileSync(manifestPath, "utf8"))
const byPath = {}

for (const entry of manifest) {
  const pagePath = pathnameFromUrl(entry.url)
  byPath[pagePath] ||= []
  const lhr = JSON.parse(fs.readFileSync(entry.jsonPath, "utf8"))
  byPath[pagePath].push(extractRun(lhr))
}

const pages = {}
for (const [pagePath, runs] of Object.entries(byPath)) {
  pages[pagePath] = {
    lcp_median_ms: round0(median(runs.map((r) => r.lcp_ms))),
    tbt_median_ms: round0(median(runs.map((r) => r.tbt_ms))),
    cls_median: round3(median(runs.map((r) => r.cls))),
    score_median: round2(median(runs.map((r) => r.score))),
    run_count: runs.length,
    final_urls: [...new Set(runs.map((r) => r.final_url))]
  }

  for (const finalUrl of pages[pagePath].final_urls) {
    if (finalUrl.includes("/signin") || finalUrl.includes("/login")) {
      console.error(
        `summarize-lhci: ${role} ${pagePath} landed on sign-in (${finalUrl}) — auth failure`
      )
      process.exit(1)
    }
  }
}

const summary = { ...meta, pages }
fs.mkdirSync(path.dirname(outputPath), { recursive: true })
fs.writeFileSync(outputPath, JSON.stringify(summary, null, 2) + "\n")
console.log(`summarize-lhci: wrote ${outputPath}`)

function extractRun(lhr) {
  return {
    lcp_ms: lhr.audits["largest-contentful-paint"].numericValue,
    tbt_ms: lhr.audits["total-blocking-time"].numericValue,
    cls: lhr.audits["cumulative-layout-shift"].numericValue,
    score: lhr.categories.performance.score,
    final_url: lhr.finalUrl || lhr.requestedUrl
  }
}

function pathnameFromUrl(url) {
  return new URL(url).pathname
}

function median(values) {
  const sorted = [...values].sort((a, b) => a - b)
  const mid = Math.floor(sorted.length / 2)
  if (sorted.length === 0) return 0
  if (sorted.length % 2 === 1) return sorted[mid]
  return (sorted[mid - 1] + sorted[mid]) / 2
}

function round0(n) {
  return Math.round(n)
}

function round2(n) {
  return Math.round(n * 100) / 100
}

function round3(n) {
  return Math.round(n * 1000) / 1000
}
