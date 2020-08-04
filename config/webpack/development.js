process.env.NODE_ENV = process.env.NODE_ENV || 'development'

const environment = require('./environment')
const webpack = require('webpack')
const dotenv = require('dotenv')

dotenv.config({path: '.env', silent: true})

environment.plugins.prepend(
  'LoadEnvironmentVariables',
  new webpack.EnvironmentPlugin(JSON.parse(JSON.stringify(process.env)))
)

module.exports = environment.toWebpackConfig()
