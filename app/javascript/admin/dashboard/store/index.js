import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

export const state = {
  chartEndpoints: {},
  cachedStates: {},
}

export const getters = {
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
}

export const mutations = {
  addChartEndpoints (state, payload) {
    const mergedEndpoints = Object.assign({}, state.chartEndpoints, payload)
    Object.keys(mergedEndpoints).forEach((key) => {
      Vue.set(state.chartEndpoints, key, mergedEndpoints[key])
    })
  },

  addChartDataToCache (state, payload) {
    Vue.set(state.cachedStates, payload.url, payload.chartData)
  },
}

export default new Vuex.Store({
  state,
  getters,
  mutations,
})
