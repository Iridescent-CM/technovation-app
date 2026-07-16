#!/usr/bin/env node
"use strict"

const fs = require("fs")
const path = require("path")

const baselineA = process.argv[2]
const baselineB = process.argv[3]

if (!baselineA || !baselineB) {
  console.error("usage: compare-baselines.js <baseline-a-dir> <baseline-b-dir>")
  process.exit(1)
}

console.log(`compare: ${baselineA}`)
console.log(`     vs ${baselineB}`)
console.log("")

compareRoleFiles(baselineA, baselineB)
compareBundles(baselineA, baselineB)
compareLayouts(baselineA, baselineB)

function compareRoleFiles(dirA, dirB) {
  const roles = [
    "public",
    "student",
    "mentor",
    "judge",
    "chapter_ambassador",
    "admin"
  ]

  for (const role of roles) {
    const fileA = path.join(dirA, `${role}.json`)
    const fileB = path.join(dirB, `${role}.json`)

    if (!fs.existsSync(fileA) && !fs.existsSync(fileB)) continue
    if (!fs.existsSync(fileA) || !fs.existsSync(fileB)) {
      console.log(`[${role}] missing in one baseline — skip`)
      continue
    }

    const a = JSON.parse(fs.readFileSync(fileA, "utf8"))
    const b = JSON.parse(fs.readFileSync(fileB, "utf8"))
    const paths = [...new Set([...Object.keys(a.pages || {}), ...Object.keys(b.pages || {})])]

    console.log(`[${role}]`)
    for (const pagePath of paths.sort()) {
      const pa = a.pages?.[pagePath]
      const pb = b.pages?.[pagePath]
      if (!pa || !pb) {
        console.log(`  ${pagePath}: missing in one baseline`)
        continue
      }

      printDelta("  ", pagePath, "LCP ms", pa.lcp_median_ms, pb.lcp_median_ms)
      printDelta("  ", pagePath, "TBT ms", pa.tbt_median_ms, pb.tbt_median_ms, true)
      printDelta("  ", pagePath, "CLS", pa.cls_median, pb.cls_median, true)
      printDelta("  ", pagePath, "score", pa.score_median, pb.score_median, true)
    }
    console.log("")
  }
}

function compareBundles(dirA, dirB) {
  const fileA = path.join(dirA, "bundles.json")
  const fileB = path.join(dirB, "bundles.json")
  if (!fs.existsSync(fileA) || !fs.existsSync(fileB)) {
    console.log("[bundles] missing bundles.json in one baseline — skip")
    return
  }

  const a = JSON.parse(fs.readFileSync(fileA, "utf8")).packs_kb || {}
  const b = JSON.parse(fs.readFileSync(fileB, "utf8")).packs_kb || {}
  const packs = [...new Set([...Object.keys(a), ...Object.keys(b)])].sort()

  console.log("[bundles] KB")
  for (const pack of packs) {
    printDelta("  ", pack, "KB", a[pack] ?? 0, b[pack] ?? 0, true)
  }
}

function compareLayouts(dirA, dirB) {
  const fileA = path.join(dirA, "bundles.json")
  const fileB = path.join(dirB, "bundles.json")
  if (!fs.existsSync(fileA) || !fs.existsSync(fileB)) {
    console.log("[layouts] missing bundles.json in one baseline — skip")
    return
  }

  const layoutsA = JSON.parse(fs.readFileSync(fileA, "utf8")).layouts
  const layoutsB = JSON.parse(fs.readFileSync(fileB, "utf8")).layouts

  if (!layoutsA || !layoutsB) {
    console.log("[layouts] missing layouts in one baseline — skip")
    return
  }

  const layouts = [...new Set([...Object.keys(layoutsA), ...Object.keys(layoutsB)])].sort()

  console.log("[layouts] transferred gzip KB")
  for (const layout of layouts) {
    printDelta(
      "  ",
      layout,
      "gzip KB",
      layoutsA[layout]?.total_gzip_kb ?? 0,
      layoutsB[layout]?.total_gzip_kb ?? 0,
      true
    )
    printDelta(
      "  ",
      layout,
      "raw KB",
      layoutsA[layout]?.total_kb ?? 0,
      layoutsB[layout]?.total_kb ?? 0,
      true
    )
  }
  console.log("")
}

function printDelta(prefix, label, metric, before, after, lowerIsBetter = false) {
  const delta = after - before
  const sign = delta > 0 ? "+" : ""
  const marker = delta === 0 ? "=" : lowerIsBetter ? (delta < 0 ? "↓" : "↑") : delta > 0 ? "↑" : "↓"
  console.log(`${prefix}${label} ${metric}: ${before} → ${after} (${sign}${fmt(delta)}) ${marker}`)
}

function fmt(n) {
  if (Number.isInteger(n)) return String(n)
  return (Math.round(n * 10) / 10).toFixed(1)
}
