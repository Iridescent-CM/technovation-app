import axios from 'axios'
import applyConverters from 'axios-case-converter'

// Polyfill Promise for IE11 to support axios
require('es6-promise').polyfill()

window.axios = applyConverters(axios.create())

document.addEventListener('turbolinks:load', () => {
  const csrfTokenMetaTag = document.querySelector('meta[name="csrf-token"]')

  // Set all axios request to go through as XHR
  window.axios.defaults.headers.common['X-Requested-With'] = 'XMLHttpRequest';

  if (csrfTokenMetaTag) {
    window.axios.interceptors.request.use(function (config) {
      if (config.url && config.url.match(/^\//)) {
        // The following headers must be in "Header-Case" because
        // of axios-case-converter (see their documentation)
        config.headers.common = {
          'X-Requested-With': 'XMLHttpRequest',
          'X-Csrf-Token' : csrfTokenMetaTag.getAttribute('content')
        }
      }

      return config
    }, function (error) {
      return Promise.reject(error);
    })
  }
})