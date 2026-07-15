#!/usr/bin/env node
"use strict"

const fs = require("fs")
const path = require("path")
const zlib = require("zlib")

const TRACKED_PACKS = [
  "application",
  "application_rebrand",
  "new_registration",
  "judge",
  "admin"
]

const LAYOUT_PACKS = {
  application: ["application"],
  judge: ["application", "application_rebrand", "judge"],
  mentor: ["application", "application_rebrand"],
  admin: ["application", "admin"],
  new_registration: ["application", "new_registration"],
  submissions: ["application", "submissions", "application_rebrand"]
}

function extractBundles(
  stats,
  { outputPath, outputDir = "public/packs", statsFile = "stats.json" } = {}
) {
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

  const assetSizeByName = buildAssetSizeIndex(stats)
  const layouts = computeLayouts(stats, assetSizeByName, outputDir)

  const output = {
    generated_at: new Date().toISOString(),
    stats_file: statsFile,
    packs_kb: kbByPack,
    layouts
  }

  const json = JSON.stringify(output, null, 2) + "\n"

  if (outputPath) {
    fs.mkdirSync(path.dirname(outputPath), { recursive: true })
    fs.writeFileSync(outputPath, json)
  }

  return output
}

function buildAssetSizeIndex(stats) {
  const index = {}
  for (const asset of stats.assets || []) {
    if (asset.name) {
      index[normalizeAssetName(asset.name)] = asset.size || 0
    }
  }
  return index
}

function normalizeAssetName(name) {
  return path.basename(name)
}

function entrypointAssets(stats, packName) {
  const entry = stats.entrypoints?.[packName]
  if (!entry?.assets) return []

  return entry.assets.map((asset) => {
    if (typeof asset === "string") return normalizeAssetName(asset)
    return normalizeAssetName(asset.name)
  })
}

function computeLayouts(stats, assetSizeByName, outputDir) {
  const layouts = {}

  for (const [layout, packs] of Object.entries(LAYOUT_PACKS)) {
    const uniqueAssets = new Set()

    for (const pack of packs) {
      for (const assetName of entrypointAssets(stats, pack)) {
        uniqueAssets.add(assetName)
      }
    }

    let jsBytes = 0
    let cssBytes = 0
    let jsGzipBytes = 0
    let cssGzipBytes = 0
    let chunkCount = 0

    for (const assetName of uniqueAssets) {
      const size = assetSizeByName[assetName] || 0
      const gzipSize = gzipSizeForAsset(assetName, outputDir)

      if (assetName.endsWith(".js")) {
        jsBytes += size
        jsGzipBytes += gzipSize
        chunkCount++
      } else if (assetName.endsWith(".css")) {
        cssBytes += size
        cssGzipBytes += gzipSize
        chunkCount++
      }
    }

    layouts[layout] = {
      packs,
      js_kb: round1(jsBytes / 1024),
      css_kb: round1(cssBytes / 1024),
      total_kb: round1((jsBytes + cssBytes) / 1024),
      js_gzip_kb: round1(jsGzipBytes / 1024),
      css_gzip_kb: round1(cssGzipBytes / 1024),
      total_gzip_kb: round1((jsGzipBytes + cssGzipBytes) / 1024),
      chunk_count: chunkCount
    }
  }

  return layouts
}

function gzipSizeForAsset(assetName, outputDir) {
  const filePath = path.join(outputDir, assetName)
  if (!fs.existsSync(filePath)) return 0

  try {
    const content = fs.readFileSync(filePath)
    return zlib.gzipSync(content).length
  } catch {
    return 0
  }
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

module.exports = {
  extractBundles,
  LAYOUT_PACKS,
  TRACKED_PACKS,
  packFromAssetName,
  round1
}

if (require.main === module) {
  const statsPath = process.argv[2] || "stats.json"
  const outPath = process.argv[3]

  if (!fs.existsSync(statsPath)) {
    console.error(`extract-bundles: missing ${statsPath} — run shakapacker --json first`)
    process.exit(1)
  }

  const stats = JSON.parse(fs.readFileSync(statsPath, "utf8"))
  const output = extractBundles(stats, { outputPath: outPath, statsFile: statsPath })

  if (!outPath) {
    process.stdout.write(JSON.stringify(output, null, 2) + "\n")
  } else {
    console.log(`extract-bundles: wrote ${outPath}`)
  }
}
