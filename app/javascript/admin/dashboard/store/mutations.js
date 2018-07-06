import Vue from 'vue'

export default {
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