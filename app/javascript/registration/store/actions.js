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
    }).then(({ data: { data: { attributes } } }) => {
      commit('wizardToken', attributes.wizardToken)
      commit('termsAgreed', attributes.termsAgreed)
    }).catch(err => console.error(err))
  },

  saveEmail ({ commit, state }, { email }) {
    axios.post('/registration/email', {
      email: {
        email,
        wizard_token: state.wizardToken,
      }
    }).then(({ data: { data: { attributes }} }) => {
      commit('email', attributes.email)
    }).catch(err => console.error(err))
  },
}