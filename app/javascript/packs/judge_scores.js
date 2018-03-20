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
    score: {
      id: null,
      comments: [],
    },

    questions: [],

    team: {
      name: '',
    },

    submission: {
      id: null,
      total_checklist_points: 0,
    },
  },

  getters: {
    comment: (state) => (sectionName) => {
      return state.score.comments[sectionName]
    },

    teamName (state) {
      return state.team.name
    },

    checklistPoints (state) {
      return state.submission.total_checklist_points
    },

    submissionId (state) {
      return state.submission.id
    },

    scorePossible: (state, getters) => (section) => {
      let possible = _.reduce(
        getters.sectionQuestions(section),
        (acc, q) => { return acc += q.worth },
        0
      )

      if (section === 'technical') possible += 10

      return possible
    },

    scoreTotal: (state) => (section) => {
      let total = _.reduce(_.filter(state.questions, q => {
        return q.section === section
      }), (acc, q) => { return acc += q.score }, 0)

      if (section === 'technical')
        total += state.submission.total_checklist_points

      return total
    },

    sectionQuestions: (state) => (section) => {
      return _.filter(state.questions, q => {
        return q.section === section
      })
    },
  },

  mutations: {
    setComment (state, commentData) {
      state.score.comments[commentData.sectionName] = commentData.text
    },

    saveComment (state, sectionName) {
      if (!state.score.comments[sectionName])
        return false

      const data = new FormData()

      data.append(
        `submission_score[${sectionName}_comment]`,
        state.score.comments[sectionName]
      )

      $.ajax({
        method: "PATCH",
        url: `/judge/scores/${state.score.id}`,

        data: data,
        contentType: false,
        processData: false,

        success: resp => {
          console.log(resp)
        },

        error: err => {
          console.error(err)
        },
      })
    },

    updateScores (state, qData) {
      let question = _.find(state.questions, q => {
        return q.section === qData.section && q.idx === qData.idx
      })

      const data = new FormData()
      data.append(`submission_score[${question.field}]`, qData.score)

      $.ajax({
        method: "PATCH",
        url: `/judge/scores/${state.score.id}`,

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

    setStateFromJSON (state, json) {
      state.questions = json.questions
      state.team = json.team
      state.submission = json.submission
      state.score = json.score
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

    watch: {
      $route (to, from) {
        this.$store.commit('saveComment', from.name)
      },
    },

    mounted () {
      $.ajax({
        method: "GET",
        url: "/judge/scores/new.json",
        success: json => {
          this.$store.commit('setStateFromJSON', json)
        },
      })
    },
  });
});
