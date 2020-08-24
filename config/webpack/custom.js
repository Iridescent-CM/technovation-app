const path = require('path')

module.exports = {
  resolve: {
    alias: {
      '@appjs': path.resolve(__dirname, '..', '..', 'app/javascript'),
      '@assetsjs': path.resolve(__dirname, '..', '..', 'app/assets/javascripts'),
      '@vendorjs': path.resolve(__dirname, '..', '..', 'vendor/assets/javascripts'),
      'vue$': 'vue/dist/vue.esm.js' // Use the full build
    }
  }
}