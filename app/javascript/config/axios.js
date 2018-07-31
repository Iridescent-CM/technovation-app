import axios from 'axios'
import applyConverters from 'axios-case-converter'

// Polyfill Promise for IE11 to support axios
require('es6-promise').polyfill()

window.axios = axios

applyConverters(window.axios)

document.addEventListener('turbolinks:load', () => {
  const csrfTokenMetaTag = document.querySelector('meta[name="csrf-token"]')

  if (csrfTokenMetaTag) {
    window.axios.interceptors.request.use(function (config) {
      if (config.url && config.url.match(/^\//)) {
        config.headers.common = {
          'X-Requested-With': 'XMLHttpRequest',
          'X-CSRF-TOKEN' : csrfTokenMetaTag.getAttribute('content')
        }
      }

      return config
    }, function (error) {
      return Promise.reject(error);
    })
  }
})