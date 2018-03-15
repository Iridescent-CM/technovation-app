import TurbolinksAdapter from 'vue-turbolinks';
import Vue from 'vue/dist/vue.esm';
import Vuex from 'vuex'

import _ from 'lodash'

Vue.use(Vuex)

import VTooltip from 'v-tooltip';

import "../components/tooltip.scss";

Vue.use(TurbolinksAdapter);
Vue.use(VTooltip);

import Ideation from "../scores/Ideation"
import Technical from "../scores/Technical"

import '../scores/main.scss'

const store = new Vuex.Store({
  state: {
    currentSection: 'ideation',
    questions: [
      {
        section: 'ideation',
        idx: 1,
        text: "The team clearly shows how " +
              "their app idea aligns " +
              "with a problem in their community.",
        worth: 5,
        score: null,
      },
      {
        section: 'ideation',
        idx: 2,
        text: "The team provides evidence of the problem they are " +
              "solving through facts and statistics.",
        worth: 5,
        score: null,
      },
      {
        section: 'ideation',
        idx: 3,
        text: "The team addresses the problem well.",
        worth: 5,
        score: null,
      },
      {
        section: 'technical',
        idx: 1,
        text: "The app appears to be fully functional " +
              "and has no noticeable",
        worth: 5,
        score: null,
      },
      {
        section: 'technical',
        idx: 2,
        text: "The app is easy to use and the " +
              "features are well thought out.",
        worth: 5,
        score: null,
      },
    ],
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
  },

  mutations: {
    changeSection (state, section) {
      state.currentSection = section
    },

    updateScores (state, question) {
      let _question = _.find(state.questions, q => {
        return q.section === question.section && q.idx === question.idx
      })

      _question.score = question.score
    },
  },
})

$(document).on('ready turbolinks:load', () => {
  new Vue({
    el: "#app",

    data: {
    },

    computed: {
      currentSection () {
        return this.$store.state.currentSection
      },
    },

    store,

    components: {
      Ideation,
      Technical
    },
  });
});
