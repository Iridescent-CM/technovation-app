import Vue from 'vue'

export default {
  refs (state, value) {
    state.refs = value
  },

  currentAccount (state, object) {
    Vue.set(state, 'currentAccount', object)
  },

  currentTeams (state, collection) {
    Vue.set(state, 'currentTeams', collection)
  },

  consentWaiver (state, object) {
    Vue.set(state, 'consentWaiver', object)
  },
}