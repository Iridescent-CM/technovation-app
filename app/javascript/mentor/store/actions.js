export default {
  initApp ({ commit }, { currentAccount, currentTeams, consentWaiver }) {
    commit('currentAccount', currentAccount)
    commit('currentTeams', currentTeams)
    commit('consentWaiver', consentWaiver)
  },
}