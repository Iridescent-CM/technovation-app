const path = require('path')

module.exports = {
  // Webpack 4 defaults to MD4; OpenSSL 3 (Node 17+) rejects it without legacy
  // provider. SHA-256 works on modern Node/Heroku without NODE_OPTIONS.
  output: {
    hashFunction: 'sha256'
  },
  resolve: {
    alias: {
      '@appjs': path.resolve(__dirname, '..', '..', 'app/javascript'),
      '@assetsjs': path.resolve(__dirname, '..', '..', 'app/assets/javascripts'),
      '@vendorjs': path.resolve(__dirname, '..', '..', 'vendor/assets/javascripts'),
      'vue$': 'vue/dist/vue.esm.js' // Use the full build
    }
  }
}