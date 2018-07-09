import Vue from 'vue/dist/vue.esm'

import store from './store'

import App from './App'

document.addEventListener('turbolinks:load', () => {
  const adminReqElem = document.querySelector('#vue-enable-admin-requests')

  if (adminReqElem) {
    new Vue({
      el: adminReqElem,
      store,
      components: {
        App,
      },
    })
  }
})