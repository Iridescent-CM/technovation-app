#!/usr/bin/env node
"use strict"

const fs = require("fs")
const path = require("path")

const TRACKED_PACKS = [
  "application",
  "application_rebrand",
  "new_registration",
  "judge",
  "admin"
]

const statsPath = process.argv[2] || "stats.json"
const outPath = process.argv[3]

if (!fs.existsSync(statsPath)) {
  console.error(`extract-bundles: missing ${statsPath} — run shakapacker --json first`)
  process.exit(1)
}

const stats = JSON.parse(fs.readFileSync(statsPath, "utf8"))
const bytesByPack = Object.fromEntries(TRACKED_PACKS.map((p) => [p, 0]))

for (const asset of stats.assets || []) {
  const pack = packFromAssetName(asset.name)
  if (pack) {
    bytesByPack[pack] += asset.size || 0
  }
}

const kbByPack = Object.fromEntries(
  Object.entries(bytesByPack).map(([pack, bytes]) => [pack, round1(bytes / 1024)])
)

const output = {
  generated_at: new Date().toISOString(),
  stats_file: statsPath,
  packs_kb: kbByPack
}

const json = JSON.stringify(output, null, 2) + "\n"

if (outPath) {
  fs.mkdirSync(path.dirname(outPath), { recursive: true })
  fs.writeFileSync(outPath, json)
  console.log(`extract-bundles: wrote ${outPath}`)
} else {
  process.stdout.write(json)
}

function packFromAssetName(name) {
  const base = path.basename(name)
  for (const pack of TRACKED_PACKS) {
    if (base === `${pack}.js` || base === `${pack}.css`) return pack
    if (base.startsWith(`${pack}-`) || base.startsWith(`${pack}.`)) return pack
  }
  return null
}

function round1(n) {
  return Math.round(n * 10) / 10
}
