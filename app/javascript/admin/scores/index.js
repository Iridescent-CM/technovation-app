import Vue from 'vue/dist/vue.esm'

import store from './store'
import { router } from './routes'

document.addEventListener('turbolinks:load', () => {
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

      mounted () {
        let url = '/admin/scores.json'

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
