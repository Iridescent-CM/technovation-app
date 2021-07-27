import Vue from 'vue'
import Vue2Filters from 'vue2-filters'

import router from './routes'
import store from './store'

import App from './App'

Vue.use(Vue2Filters)

document.addEventListener('DOMContentLoaded', () => {
  const wizardElem = document.querySelector('#vue-enable-signup-wizard')

  if (wizardElem) {
    const rootElem = document.getElementById('vue-data-registration')
    const { data } = JSON.parse(rootElem.dataset.previousAttempt)
    const { attributes, relationships } = data
    let storePromise

    if (data.type === 'account') {
      const currentAccount = Object.assign({}, store.state.registration, attributes, relationships)
      storePromise = store.dispatch('registration/initAccount', currentAccount)
    } else {
      const previousAttempt = Object.assign({}, store.state.registration, attributes, relationships)
      storePromise = store.dispatch('registration/initWizard', previousAttempt)
    }

    storePromise.then(() => {
      new Vue({
        el: wizardElem,
        store,
        router,
        components: {
          App,
        },
      })

      ga('set', 'page', router.currentRoute.path);
      ga('send', 'pageview');

      router.afterEach(( to, from ) => {
        ga('set', 'page', to.path);
        ga('send', 'pageview');
      });
    })
  }
})
