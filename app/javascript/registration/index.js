import Vue from 'vue/dist/vue.esm'

import router from './routes'
import store from './store'

import App from './App'

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
      created () {
        if (!router.currentRoute.name)
          router.replace({ name: 'data-use' })
      },
    })

    router.beforeEach((to, _from, next) => {
      if (to.matched.some(record => record.name !== 'data-use')) {
        if (!store.state.termsAgreed) {
          next({ name: 'data-use' })
        } else {
          next()
        }
      } else {
        next()
      }
    })
  }
})