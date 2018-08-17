import Vue from 'vue/dist/vue.esm'
import Vue2Filters from 'vue2-filters'

import router from './routes'
import store from 'registration/store'

import App from './App'

Vue.use(Vue2Filters)

document.addEventListener('turbolinks:load', () => {
  const appElem = document.querySelector('#vue-enable-student-app')

  if (appElem) {
    new Vue({
      el: appElem,
      store,
      router,
      components: {
        App,
      },
    })
  }
})