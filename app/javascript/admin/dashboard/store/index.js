import Vue from 'vue/dist/vue.esm'
import Vuex from 'vuex'

Vue.use(Vuex)

export default new Vuex.Store({
  state: {
    chartEndpoints: {},
    cachedStates: {},
  },

  getters: {
    getChartEndpoint: (state) => (name) => {
      if (state.chartEndpoints[name])
        return state.chartEndpoints[name]

      return ''
    },

    getCachedChartData: (state) => (name) => {
      const url = state.chartEndpoints[name]

      if (state.cachedStates[url])
        return state.cachedStates[url]

      return {}
    }
  },

  mutations: {
    addChartEndpoints (state, payload) {
      const mergedEndpoints = Object.assign({}, state.chartEndpoints, payload)
      state.chartEndpoints = payload
    },

    addChartDataToCache (state, payload) {
      state.cachedStates[payload.url] = payload.chartData
    },
  },
})
