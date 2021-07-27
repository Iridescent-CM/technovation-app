import Vue from 'vue'

import store from './store'
import { router } from './routes'

import { mapState } from 'vuex'

document.addEventListener('DOMContentLoaded', () => {
  const scoresEl = document.querySelector("#admin-scores-app")

  if (scoresEl != undefined) {
    new Vue({
      el: scoresEl,
      router,
      store,

      data () {
        return {
          notice: '',
        }
      },

      computed: mapState(['ready']),

      mounted () {
        let url = '/admin/suspicious_scores.json'

        $.ajax({
          method: "GET",
          url: url,
          success: json => {
            this.$store.dispatch('initApp', json)
          },
          error: (xhr, ajaxOptions, thrownError) => {
            this.notice = xhr.responseJSON.msg
          },
        })
      },
    });
  }
})
