import Vue from 'vue/dist/vue.esm'
import { mapActions } from 'vuex'

import router from './routes'
import store from './store'

import TabLink from '../tabs/components/TabLink'

document.addEventListener('turbolinks:load', () => {
  const wizardElem = document.querySelector('#vue-enable-signup-wizard')

  if (wizardElem) {
    const previousAttempt = wizardElem.dataset.previousAttempt

    new Vue({
      el: wizardElem,

      store,
      router,

      components: {
        TabLink,
      },

      data: {
        isReady: false,
      },

      created() {
        if (!router.currentRoute.name) router.replace({ name: 'data-use' })

        if (previousAttempt) {
          this.initWizard({ previousAttempt })
          this.isReady = true
        } else {
          this.isReady = true
        }
      },

      methods: mapActions(['initWizard']),
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