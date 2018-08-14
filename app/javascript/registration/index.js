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
        router.replace({ name: this.getCurrentStep })
      },
      computed: {
        onLoginStep () {
          return !!this.$store.getters.readyForAccount
        },

        onBasicProfileStep () {
          if (
            this.$store.state.termsAgreed &&
            this.$store.getters.isAgeSet &&
            this.$store.state.profileChoice &&
            this.$store.getters.isLocationSet
          ) {
            return true
          }

          return false
        },

        onLocationStep () {
          if (
            this.$store.state.termsAgreed &&
            this.$store.getters.isAgeSet &&
            this.$store.state.profileChoice
          ) {
            return true
          }

          return false
        },

        onAgeStep () {
          if (this.$store.state.termsAgreed) {
            return true
          }

          return false
        },

        getCurrentStep () {
          let step = 'data-use'

          if (this.onLoginStep) {
            return 'login'
          } else if (this.onBasicProfileStep) {
            return 'basic-profile'
          } else if (this.onAgeStep) {
            return 'age'
          } else if (this.onLocationStep) {
            return 'location'
          }

          return step
        },
      },
    })
  }
})