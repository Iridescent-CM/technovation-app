export default {
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