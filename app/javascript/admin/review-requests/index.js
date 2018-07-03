import Vue from 'vue/dist/vue.esm'

import store from './store'

import ReviewRegionRequests from './components/ReviewRegionRequests'

document.addEventListener('turbolinks:load', () => {
  const adminReqElems = document.querySelectorAll('.vue-enable-admin-requests')

  adminReqElems.forEach((elem) => {
    new Vue({
      el: elem,
      store,

      components: {
        ReviewRegionRequests,
      },
    })
  })
})
