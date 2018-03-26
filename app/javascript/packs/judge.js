import Vue from 'vue/dist/vue.esm'

import VueRouter from 'vue-router'
import TurbolinksAdapter from 'vue-turbolinks'
import VTooltip from 'v-tooltip'
import Vue2Filters from 'vue2-filters'

import _ from 'lodash'

import dashboardStore from '../judge/dashboards/scores/store'
import { dashboardAppRouter } from '../judge/dashboards/scores/routes'

import scoresStore from '../judge/scores/store'
import { scoresAppRouter } from '../judge/scores/routes'

import ScoreStepper from "../judge/scores/ScoreStepper"

import "../components/tooltip.scss";
import '../judge/scores/main.scss'

Vue.use(VueRouter)
Vue.use(TurbolinksAdapter);
Vue.use(VTooltip)
Vue.use(Vue2Filters)

document.addEventListener('turbolinks:load', () => {
  const dashEl = document.querySelector('#judge-dashboard-scores-app')

  if (dashEl != undefined) {
    new Vue({
      el: dashEl,
      router: dashboardAppRouter,
      store: dashboardStore,

      mounted () {
        $.get("/judge/scores.json", null, resp => {
          this.$store.commit('populateScores', resp)
        })

        if (this.$refs.disableAssigned) {
          this.$router.push({ name: 'finished-scores' })
        } else {
          $.get("/judge/assigned_submissions.json", null, resp => {
            this.$store.commit('populateSubmissions', resp)
          })
        }
      },
    })
  }

  const scoresEl = document.querySelector("#judge-scores-app")

  if (scoresEl != undefined) {
    new Vue({
      el: scoresEl,
      router: scoresAppRouter,
      store: scoresStore,

      data: {
        msg: '',
      },

      props: ['scoreId'],

      components: {
        ScoreStepper,
      },

      watch: {
        $route (to, from) {
          this.$store.commit('saveComment', from.name)
        },
      },

      mounted () {
        const score_id = new URLSearchParams(window.location.search)
          .get('score_id')

        $.ajax({
          method: "GET",
          url: `/judge/scores/new.json?score_id=${score_id}`,
          success: json => {
            this.$store.commit('setStateFromJSON', json)
          },
          error: (xhr, ajaxOptions, thrownError) => {
            this.msg = xhr.responseJSON.msg
          },
        })
      },
    });
  }
})
