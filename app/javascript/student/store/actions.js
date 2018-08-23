export default {
  initApp ({ commit }, { currentAccount, currentTeam, parentalConsent }) {
    commit('currentAccount', currentAccount)
    commit('currentTeam', currentTeam)
    commit('parentalConsent', parentalConsent)
  },
}