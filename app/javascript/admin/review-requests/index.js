import Vue from 'vue/dist/vue.esm'

import ReviewRegionRequests from './ReviewRegionRequests'

document.addEventListener('turbolinks:load', () => {
  const reviewRequestsElem = document.querySelector('#vue-enable-admin-requests')

  new Vue({
    el: reviewRequestsElem,

    components: {
      ReviewRegionRequests,
    },
  })
})
