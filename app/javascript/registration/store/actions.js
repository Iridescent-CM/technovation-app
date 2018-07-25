export default {
  initWizard ({ commit }, { previousAttempt }) {
    const { data: { attributes } } = JSON.parse(previousAttempt)
    commit('wizardToken', attributes.wizardToken)
    commit('termsAgreed', attributes.termsAgreed)
    commit('email', attributes.email)
  },

  updateTermsAgreed ({ commit, state }, { termsAgreed }) {
    axios.post('/registration/terms_agreement', {
      terms_agreed: termsAgreed,
      wizard_token: state.wizardToken,
    }).then(({ data }) => {
      const attrs = Object.assign({}, data.data).attributes
      const resp = Object.assign({}, attrs)
      commit('termsAgreed', resp.termsAgreed)
    }).catch(err => console.error(err))
  },
}