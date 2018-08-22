export default {
  initApp ({ commit }, { currentAccount, currentTeam }) {
    commit('currentAccount', currentAccount)
    commit('currentTeam', currentTeam)
  },
}