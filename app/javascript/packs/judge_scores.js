import TurbolinksAdapter from 'vue-turbolinks';

import Vue from 'vue/dist/vue.esm';
import Vuex from 'vuex'
import VueRouter from 'vue-router'
import VTooltip from 'v-tooltip';

import _ from 'lodash'

import ScoreStepper from "../scores/ScoreStepper"
import routes from '../scores/routes'

import "../components/tooltip.scss";
import '../scores/main.scss'

Vue.use(Vuex)
Vue.use(VueRouter)
Vue.use(TurbolinksAdapter);
Vue.use(VTooltip);

const router = new VueRouter({
  routes,
})

const store = new Vuex.Store({
  state: {
    questions: [],
  },

  getters: {
    ideationQuestions (state) {
      return _.filter(state.questions, q => {
        return q.section === 'ideation'
      })
    },

    technicalQuestions (state) {
      return _.filter(state.questions, q => {
        return q.section === 'technical'
      })
    },

    pitchQuestions (state) {
      return _.filter(state.questions, q => {
        return q.section === 'pitch'
      })
    },

    entrepreneurshipQuestions (state) {
      return _.filter(state.questions, q => {
        return q.section === 'entrepreneurship'
      })
    },

    overallQuestions (state) {
      return _.filter(state.questions, q => {
        return q.section === 'overall'
      })
    },
  },

  mutations: {
    updateScores (state, qData) {
      let question = _.find(state.questions, q => {
        return q.section === qData.section && q.idx === qData.idx
      })

      const data = new FormData()
      data.append(`submission_score[${question.field}]`, qData.score)

      $.ajax({
        method: "PATCH",
        url: question.update,

        data: data,
        contentType: false,
        processData: false,

        success: resp => {
          question.score = qData.score
        },

        error: err => {
          console.error(err)
        },
      })
    },

    populateQuestions (state, json) {
      state.questions = json
    },
  },
})

$(document).on('ready turbolinks:load', () => {
  new Vue({
    el: "#app",

    router,

    store,

    computed: {
    },

    components: {
      ScoreStepper,
    },

    mounted () {
      $.ajax({
        method: "GET",
        url: "/judge/scores/new.json",
        success: json => {
          this.$store.commit('populateQuestions', json)
        },
      })
    },
  });
});
