import Vue from 'vue/dist/vue.esm'
import Vuex from 'vuex'

Vue.use(Vuex)

export default new Vuex.Store({
  state: {
    chartEndpoints: {},
  },

  mutations: {
    addChartEndpoints (state, payload) {
      const mergedEndpoints = Object.assign({}, state.chartEndpoints, payload)
      state.chartEndpoints = payload
    },
  },
})
