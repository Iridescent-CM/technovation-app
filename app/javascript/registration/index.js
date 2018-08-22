import Vue from 'vue/dist/vue.esm'
import Vue2Filters from 'vue2-filters'

import router from './routes'
import store from './store'

import App from './App'

Vue.use(Vue2Filters)

document.addEventListener('turbolinks:load', () => {
  const wizardElem = document.querySelector('#vue-enable-signup-wizard')

  if (wizardElem) {
    new Vue({
      el: wizardElem,
      store,
      router,
      components: {
        App,
      },
    })
  }
})