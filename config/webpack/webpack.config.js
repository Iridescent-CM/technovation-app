const path = require("path")
const webpack = require("webpack")
const { generateWebpackConfig } = require("shakapacker")
const { VueLoaderPlugin } = require("vue-loader")

const railsEnv = process.env.RAILS_ENV || process.env.NODE_ENV || "development"
if (railsEnv === "development" || railsEnv === "test") {
  try {
    require("dotenv").config({
      path: path.resolve(__dirname, "..", "..", ".env"),
      silent: true
    })
  } catch (_e) {
    // dotenv is optional at runtime
  }
}

const CLIENT_ENV_KEYS = [
  "AIRBRAKE_PROJECT_ID",
  "AIRBRAKE_PROJECT_KEY",
  "AIRBRAKE_RAILS_ENV",
  "AWS_BUCKET_NAME",
  "BEGINNER_DIVISION_JUDGING_RUBRIC_URL",
  "DATES_DIVISION_CUTOFF_DAY",
  "DATES_DIVISION_CUTOFF_MONTH",
  "DATES_DIVISION_CUTOFF_YEAR",
  "DATES_REGIONAL_PITCH_EVENTS_BEGINS_DAY",
  "DATES_REGIONAL_PITCH_EVENTS_BEGINS_MONTH",
  "DATES_REGIONAL_PITCH_EVENTS_BEGINS_YEAR",
  "DATES_REGIONAL_PITCH_EVENTS_ENDS_DAY",
  "DATES_REGIONAL_PITCH_EVENTS_ENDS_MONTH",
  "DATES_REGIONAL_PITCH_EVENTS_ENDS_YEAR",
  "FILESTACK_API_KEY",
  "GENERAL_JUDGING_RUBRIC_URL",
  "HELP_EMAIL",
  "HOST_DOMAIN",
  "JUDGE_MAXIMUM_NUMBER_OF_RECUSALS",
  "JUNIOR_DIVISION_JUDGING_RUBRIC_URL",
  "SENIOR_DIVISION_JUDGING_RUBRIC_URL"
]

const clientEnv = {}
for (const key of CLIENT_ENV_KEYS) {
  clientEnv[key] = process.env[key] ?? null
}

// Merge resolve/plugins only — merging `module.rules` can introduce `oneOf`,
// which vue-loader 15 rejects. Register the Vue rule at the front instead.
const config = generateWebpackConfig({
  resolve: {
    fallback: {
      os: false
    },
    alias: {
      "@appjs": path.resolve(__dirname, "..", "..", "app/javascript"),
      "@assetsjs": path.resolve(__dirname, "..", "..", "app/assets/javascripts"),
      "@vendorjs": path.resolve(__dirname, "..", "..", "vendor/assets/javascripts"),
      vue$: "vue/dist/vue.esm.js"
    },
    extensions: [
      ".vue",
      ".mjs",
      ".js",
      ".sass",
      ".scss",
      ".css",
      ".module.sass",
      ".module.scss",
      ".module.css",
      ".png",
      ".svg",
      ".gif",
      ".jpeg",
      ".jpg"
    ]
  },
  plugins: [new webpack.EnvironmentPlugin(clientEnv)]
})

config.module.rules.unshift({
  test: /\.vue(\.erb)?$/,
  use: [{ loader: "vue-loader" }]
})
config.plugins.unshift(new VueLoaderPlugin())

module.exports = config
