import Vue from 'vue/dist/vue.esm'
import Vuex from 'vuex'

Vue.use(Vuex)

export default new Vuex.Store({
  state: {
    chartEndpoints: {},
    cachedStates: {},
    totals: {},
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
    },

    getTotalByName: (state) => (name) => {
      if (state.totals[name])
        return state.totals[name]

      return null
    }
  },

  mutations: {
    addChartEndpoints (state, payload) {
      const mergedEndpoints = Object.assign({}, state.chartEndpoints, payload)
      state.chartEndpoints = mergedEndpoints
    },

    addChartDataToCache (state, payload) {
      state.cachedStates[payload.url] = payload.chartData
    },

    addTotals (state, payload) {
      const mergedTotals = Object.assign({}, state.totals, payload)
      state.totals = mergedTotals
    },
  },
})
