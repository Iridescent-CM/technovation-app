import Vue from 'vue';
import Vue2Filters from 'vue2-filters';

import store from './store';

import App from './App';

Vue.use(Vue2Filters);

document.addEventListener('DOMContentLoaded', () => {
  const wizardElem = document.querySelector('#vue-enable-terms-agreement-app');

  if (wizardElem) {
    const rootElem = document.getElementById('vue-data-account-information');

    const storePromise = store.dispatch('registration/initAccount', rootElem.dataset);

    storePromise.then(() => {
      if (Boolean(store.state.registration.termsAgreed)) {
        store.state.registration.isLocked = true;
      } else {
        store.state.registration.isLocked = false;
      }

      new Vue({
        el: wizardElem,
        store,
        components: {
          App,
        },
        mounted () {
          this.$el.classList.remove('hidden');
        },
      });
    });
  }
});
