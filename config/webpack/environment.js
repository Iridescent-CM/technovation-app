const { environment } = require('@rails/webpacker')
const customConfig = require('./custom')
const vue = require('./loaders/vue')

environment.loaders.append('vue', vue)

environment.config.merge(customConfig)

const webpack = require('webpack')
const dotenv = require('dotenv');

environment.plugins.append(
  'CommonsChunkVendor',
  new webpack.optimize.CommonsChunkPlugin({
    name: 'vendor',
    minChunks: (module) => {
      // this assumes your vendor imports exist in the node_modules directory
      return module.context && module.context.indexOf('node_modules') !== -1
    }
  })
)

environment.plugins.append(
  'CommonsChunkManifest',
  new webpack.optimize.CommonsChunkPlugin({
    name: 'manifest',
    minChunks: Infinity
  })
)

environment.plugins.prepend(
  'MomentIgnoreLocales',
  new webpack.IgnorePlugin(/^\.\/locale$/, /moment$/)
)

// Pull in .env variables used by front-end
const dotenvFiles = [
  '.env.local',
  '.env',
];

dotenvFiles.forEach((dotenvFile) => {
  dotenv.config({ path: dotenvFile, silent: true })
})

environment.plugins.prepend(
  'LoadEnvironmentVariables',
  new webpack.EnvironmentPlugin(JSON.parse(JSON.stringify(process.env)))
)

module.exports = environment
