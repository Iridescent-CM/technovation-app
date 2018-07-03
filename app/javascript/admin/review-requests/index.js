import Vue from 'vue/dist/vue.esm'

import ReviewRegionRequests from './ReviewRegionRequests'

document.addEventListener('turbolinks:load', () => {
  const adminReqElems = document.querySelectorAll('.vue-enable-admin-requests')

  adminReqElems.forEach((elem) => {
    new Vue({
      el: elem,

      components: {
        ReviewRegionRequests,
      },
    })
  })
})
