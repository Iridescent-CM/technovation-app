import Vue from 'vue'

import store from './scores/store'

import FinishedScoresList from './scores/FinishedScoresList'
import NotStartedScoresList from './scores/NotStartedScoresList'

import { airbrake } from 'utilities/utilities'

Vue.config.errorHandler = function (err, vm, info) {
  airbrake.notify({
    error: err,
    params: { info: info },
  })
}

document.addEventListener('turbo:load', () => {
  const dashEl = document.querySelector('#judge-dashboard-scores-app')

  if (dashEl != undefined) {
    new Vue({
      el: dashEl,
      store,

      components: {
        FinishedScoresList,
        NotStartedScoresList,
      },

      mounted () {
        $.get("/judge/scores.json", null, resp => {
          this.$store.commit('populateScores', resp)
        })
          .fail((jqXHR, textStatus, errorThrown) => {
            airbrake.notify({
              error: errorThrown,
              params: { jqXHR, textStatus, errorThrown },
            });

            displayFlashMessage(
              'There was an issue fetching your scores. Please try refreshing the page.',
              'error'
            );
          });

        if (this.$refs.deadline)
          this.$store.commit('deadline', this.$refs.deadline.dataset.date)
      },
    })
  }
})
