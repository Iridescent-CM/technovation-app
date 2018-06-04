import URLSearchParams from 'url-search-params'
import Vue from 'vue/dist/vue.esm'

import store from './store'
import { router } from './routes'

import AirbrakeClient from 'airbrake-js';

const airbrake = new AirbrakeClient({
  projectId: 107438,
  projectKey: '25c7abb3eb366a19a0743c5f04a9320e',
})

Vue.config.errorHandler = function (err, vm, info) {
  airbrake.notify({
    error: err,
    params: { info: info },
  })
}

import './stepper'

document.addEventListener('turbolinks:load', () => {
  const scoresEl = document.querySelector("#judge-scores-app")

  if (scoresEl != undefined) {
    new Vue({
      el: scoresEl,
      router,
      store,

      data: {
        notice: '',
      },

      props: ['scoreId'],

      mounted () {
        if (this.$refs.deadline)
          this.$store.commit('deadline', this.$refs.deadline.dataset.date)

        const score_id = new URLSearchParams(window.location.search)
          .get('score_id')

        const submission_id = new URLSearchParams(window.location.search)
          .get('team_submission_id')

        let url = '/judge/scores/new.json'
        url += `?score_id=${score_id}`
        url += `&team_submission_id=${submission_id}`

        $.ajax({
          method: "GET",
          url: url,
          success: json => {
            this.$store.commit('setStateFromJSON', json)
          },
          error: (xhr, ajaxOptions, thrownError) => {
            this.notice = xhr.responseJSON.msg
          },
        })

        $(".col--sticky").stick_in_parent({
          parent: ".col--sticky-parent",
          spacer: ".col--sticky-spacer",
          recalc_every: 1,
          offset_top: 80,
        });
      },

      updated () {
        $(".col--sticky").stick_in_parent({
          parent: ".col--sticky-parent",
          spacer: ".col--sticky-spacer",
          recalc_every: 1,
          offset_top: 80,
        });
      },
    });
  }
})
