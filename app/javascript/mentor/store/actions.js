export default {
  initApp ({ commit }, { currentAccount, currentMentor, currentTeams, consentWaiver, backgroundCheck }) {
    commit('currentAccount', currentAccount)
    commit('currentMentor', currentMentor)
    commit('currentTeams', currentTeams)
    commit('consentWaiver', consentWaiver)
    commit('backgroundCheck', backgroundCheck)
  },
}