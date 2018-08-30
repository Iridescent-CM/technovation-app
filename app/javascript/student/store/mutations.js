import Vue from 'vue'

export default {
  refs (state, value) {
    state.refs = value
  },

  currentAccount (state, object) {
    Vue.set(state, 'currentAccount', object)
  },

  currentTeam (state, object) {
    Vue.set(state, 'currentTeam', object)
  },

  parentalConsent (state, object) {
    Vue.set(state, 'parentalConsent', object)
  },
}