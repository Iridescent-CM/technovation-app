import Vue from 'vue/dist/vue.esm'
import router from './routes'

import TabLink from '../tabs/components/TabLink'

document.addEventListener('turbolinks:load', () => {
  const wizardElem = document.querySelector('#vue-enable-signup-wizard')

  if (wizardElem) {
    const previousAttemptUrl = wizardElem.dataset.previousAttemptUrl

    new Vue({
      el: wizardElem,

      router,

      components: {
        TabLink,
      },

      data: {
        email: null,
        canContinue: null,
        isReady: false,
      },

      created() {
        if (!router.currentRoute.name) router.replace({ name: 'email' })

        if (previousAttemptUrl) {
          axios.get(previousAttemptUrl).then(({ data }) => {
            const attrs = Object.assign({}, data.data).attributes
            const resp = Object.assign({}, attrs)

            this.email = resp.email
            this.canContinue = true

            this.isReady = true
          }).catch(err => {
            console.error(err)
          })
        } else {
          this.isReady = true
          this.canContinue = false
        }
      },
    })
  }
})