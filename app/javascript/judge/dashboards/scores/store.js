import Vue from 'vue/dist/vue.esm';
import Vuex from 'vuex'

Vue.use(Vuex)

export default new Vuex.Store({
  state: {
    currentRound: 'qf',

    scores: {
      finished: {
        qf: [],
        sf: [],
      },

      incomplete: {
        qf: [],
        sf: [],
      },
    },

    submissions: {}
  },

  getters: {
    finishedScores (state) {
      return state.scores.finished[state.currentRound]
    },

    quarterFinalsScores (state) {
      return state.scores.incomplete.qf
    },

    semiFinalsScores (state) {
      return state.scores.incomplete.sf
    },

    assignedSubmissions (state) {
      return state.submissions
    },
  },

  mutations: {
    populateScores (state, payload) {
      state.scores = payload
      state.currentRound = payload.current_round
    },

    populateSubmissions (state, payload) {
      state.submissions = payload
    },
  },
})
