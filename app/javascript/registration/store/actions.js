export default {
  initWizard ({ commit, getters }, { previousAttempt }) {
    const { data: { attributes } } = JSON.parse(previousAttempt)

    commit('wizardToken', attributes.wizardToken)
    commit('termsAgreed', attributes.termsAgreed)
    commit('birthDate', getters.getBirthdateAttributes(attributes))
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

  updateBirthdate ({ commit, state, getters }, { year, month, day }) {
    axios.post('/registration/age', {
      birth_date: {
        year,
        month: Object.assign({}, month).value,
        day,
        wizard_token: state.wizardToken,
      },
    }).then(({ data: { data: { attributes }} }) => {
      commit('birthDate', getters.getBirthdateAttributes(attributes))
    }).catch(err => console.error(err))
  },

  updateBasicProfile ({ commit, state }, attributes) {
    axios.post('/registration/basic_profile', {
      basic_profile: {
        ...attributes,
        wizard_token: state.wizardToken,
      },
    }).then(({ data: { data: { attributes }} }) => {
      commit('basicProfile',  attributes)
    }).catch(err => console.error(err))
  },
}