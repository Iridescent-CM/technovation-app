import Vue from 'vue'

export default {
  refs (state, value) {
    state.refs = value
  },

  currentAccount (state, object) {
    Vue.set(state, 'currentAccount', object)
  },

  currentMentor (state, object) {
    Vue.set(state, 'currentMentor', object)
  },

  currentTeams (state, collection) {
    Vue.set(state, 'currentTeams', collection)
  },

  consentWaiver (state, object) {
    Vue.set(state, 'consentWaiver', object)
  },

  backgroundCheck (state, object) {
    Vue.set(state, 'backgroundCheck', object)
  },
}