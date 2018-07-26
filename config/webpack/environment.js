const { environment } = require('@rails/webpacker')
const customConfig = require('./custom')
const vue =  require('./loaders/vue')

environment.loaders.append('vue', vue)

environment.config.merge(customConfig)

module.exports = environment
