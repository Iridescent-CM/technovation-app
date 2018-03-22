import Vue from 'vue/dist/vue.esm';
import Vuex from 'vuex'

Vue.use(Vuex)

export default new Vuex.Store({
  state: {
    scores: {}
  },

  getters: {
    finishedScores (state) {
      return state.scores.finished
    },
  },

  mutations: {
    populateScores (state, payload) {
      state.scores = payload
    },
  },
})
