import Vue from 'vue'
import Vue2Filters from 'vue2-filters'

import router from './routes'
import store from './store'

import App from './App'

Vue.use(Vue2Filters)

document.addEventListener('turbolinks:load', () => {
  const appElem = document.querySelector('#vue-enable-student-app')

  if (appElem) {
    const rootElem = document.getElementById('vue-data-registration')

    if (!rootElem) return false

    const registrationInitialized = store.dispatch(
      'registration/initAccount',
      rootElem.dataset
    )

    const authenticatedInitialized = store.dispatch(
      'authenticated/initApp',
      rootElem.dataset
    )

    Promise.all([registrationInitialized, authenticatedInitialized]).then(() => {
      new Vue({
        el: appElem,
        store,
        router,
        components: {
          App,
        },

        mounted () {
          this.$el.classList.remove('hidden')
        },
      })
    })
  }
})