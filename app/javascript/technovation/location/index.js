import Vue from 'vue/dist/vue.esm'

import store from './store'
import { router } from './routes'

document.addEventListener('turbolinks:load', () => {
  const locationEl = document.querySelector('#location-app')

  if (locationEl != undefined) {
    new Vue({
      el: locationEl,
      router,
      store,
    })
  }
})
