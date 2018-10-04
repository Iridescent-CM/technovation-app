import Vue from 'vue'
import Vue2Filters from 'vue2-filters'

import router from './routes'
import store from './store'

import App from './App'

Vue.use(Vue2Filters)

document.addEventListener('turbolinks:load', () => {
  const appElem = document.querySelector('#vue-enable-mentor-app')

  if (appElem) {
    const rootElem = document.getElementById('vue-data-registration')

    if (!rootElem) return false

    const authenticatedInitialized = store.dispatch(
      'authenticated/initApp',
      rootElem.dataset
    )

    const registrationInitialized = store.dispatch(
      'registration/initAccount',
      rootElem.dataset
    )

    Promise.all([authenticatedInitialized, registrationInitialized]).then(() => {
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

      ga('set', 'page', router.currentRoute.path);
      ga('send', 'pageview');

      router.afterEach(( to, from ) => {
        ga('set', 'page', to.path);
        ga('send', 'pageview');
      });
    })
  }
})