import Vue from 'vue'

export default {
  addRequest (state, request) {
    const idx = state.allRequests.findIndex(r => r.id === request.id)
    if (idx === -1) {
      state.allRequests.push(request)
    } else {
      return false
    }
  },

  replaceRequest (state, request) {
    const idx = state.allRequests.findIndex(r => r.id === request.id)

    if (idx !== -1) {
      Vue.set(state.allRequests, idx, request)
    } else {
      return false
    }
  },
}