export default {
  initWizard ({ commit, getters }, { previousAttempt }) {
    const { data: { attributes } } = JSON.parse(previousAttempt)

    commit('wizardToken', attributes.wizardToken)
    commit('termsAgreed', attributes.termsAgreed)
    commit('birthDate', getters.getBirthdateAttributes(attributes))
    commit('location', attributes)
    commit('basicProfile', attributes)
    commit('email', attributes.email)
    commit('isReady', true)
  },

  updateTermsAgreed ({ commit, state }, { termsAgreed }) {
    commit('termsAgreed', termsAgreed)

    axios.post('/registration/terms_agreement', {
      termsAgreed,
      wizardToken: state.wizardToken,
    }).then(({ data: { data: { attributes } } }) => {
      commit('wizardToken', attributes.wizardToken)
      commit('termsAgreed', attributes.termsAgreed)
      commit('location', attributes)
    }).catch(err => console.error(err))
  },

  saveEmail ({ commit, state }, { email }) {
    commit('email', email)

    axios.post('/registration/email', {
      email: {
        email,
        wizardToken: state.wizardToken,
      }
    }).then(({ data: { data: { attributes }} }) => {
      commit('email', attributes.email)
    }).catch(err => console.error(err))
  },

  updateBirthdate ({ commit, state, getters }, { year, month, day }) {
    commit(
      'birthDate',
      getters.getBirthdateAttributes({
        birthYear: year,
        birthMonth: Object.assign({}, month).value,
        birthDay: day,
      })
    )

    axios.post('/registration/age', {
      birth_date: {
        year,
        month: Object.assign({}, month).value,
        day,
        wizardToken: state.wizardToken,
      },
    }).then(({ data: { data: { attributes }} }) => {
      commit('birthDate', getters.getBirthdateAttributes(attributes))
    }).catch(err => console.error(err))
  },

  updateLocation ({ commit, state }, attrs) {
    const data = Object.assign({}, {
      city: state.city,
      state: state.state,
      country: state.country,
    }, attrs)

    commit('location', data)

    axios.post('/registration/location', {
      location: {
        ...data,
        wizardToken: state.wizardToken,
      },
    }).then(({ data: { data: { attributes }} }) => {
      commit('location', attributes)
    }).catch(err => console.error(err))
  },

  updateBasicProfile ({ commit, state }, data) {
    axios.post('/registration/basic_profile', {
      basicProfile: {
        ...data,
        wizardToken: state.wizardToken,
      },
    }).then(({ data: { data: { attributes }} }) => {
      commit('basicProfile',  attributes)
    }).catch(err => console.error(err))
  },
}