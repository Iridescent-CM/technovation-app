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
      created () {
        router.replace({ name: this.getCurrentStep })
      },
      computed: {
        onLoginStep () {
          return !!this.$store.getters.readyForAccount
        },

        onChooseProfileStep () {
          return !!(this.$store.state.termsAgreed &&
                    this.$store.getters.isAgeSet &&
                      !this.$store.state.profileChoice)
        },

        onBasicProfileStep () {
          return !!(this.$store.state.termsAgreed &&
                    this.$store.getters.isAgeSet &&
                      this.$store.state.profileChoice &&
                        this.$store.getters.isLocationSet)
        },

        onLocationStep () {
          return !!(this.$store.state.termsAgreed &&
                      this.$store.getters.isAgeSet &&
                        this.$store.state.profileChoice)
        },

        onAgeStep () {
          return !!this.$store.state.termsAgreed
        },

        getCurrentStep () {
          let step = 'data-use'

          if (this.onLoginStep) {
            return 'login'
          } else if (this.onBasicProfileStep) {
            return 'basic-profile'
          } else if (this.onChooseProfileStep) {
            return 'choose-profile'
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