import Vue from 'vue/dist/vue.esm';
import Vuex from 'vuex'

Vue.use(Vuex)

export default new Vuex.Store({
  state: {
    scores: {
      finished: [],
    },

    submissions: {}
  },

  getters: {
    finishedScores (state) {
      return state.scores.finished
    },

    assignedSubmissions (state) {
      return state.submissions
    },
  },

  mutations: {
    populateScores (state, payload) {
      state.scores = payload
    },

    populateSubmissions (state, payload) {
      state.submissions = payload
    },
  },
})
