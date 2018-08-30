import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

export default new Vuex.Store({
  state: {
    scores: [],
    ready: false,
  },

  mutations: {
    ready (state, bool) {
      state.ready = bool
    },

    scores (state, payload) {
      state.scores = payload
    },
  },

  actions: {
    initApp ({ commit }, jsonPayload) {
      commit('scores', jsonPayload.data.map((data) => data.attributes))
      commit('ready', true)
    },
  },
})
