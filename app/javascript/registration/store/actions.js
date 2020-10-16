export default {
  initWizard ({ commit, getters }, attempt) {
    commit('wizardToken', attempt.wizardToken)
    commit('token', attempt.wizardToken)

    commit('termsAgreed', attempt.termsAgreed)
    commit('termsAgreedDate', attempt.termsAgreedDate)
    commit('birthDate', getters.getBirthdateAttributes(attempt))
    commit('profileChoice', attempt.profileChoice)
    commit('location', attempt)
    commit('basicProfile', attempt)
    commit('email', attempt.email)

    commit('isReady', true)
  },

  initAccount ({ commit, getters, state }, dataset) {
    const {
      data: {
        id: accountId,
        attributes: accountAttributes,
        relationships
      }
    } = JSON.parse(dataset.currentAccount)

    const account = Object.assign(
      { id: parseInt(accountId) },
      state.registration,
      accountAttributes,
      relationships
    )

    commit('apiRoot', account.apiRoot)

    commit('termsAgreedDate', account.termsAgreedDate)

    commit('birthDate', getters.getBirthdateAttributes(account))
    commit('profileChoice', account.profileChoice)
    commit('location', account)
    commit('basicProfile', account)
    commit('email', account.email)

    commit('termsAgreed', account.termsAgreed)
    commit('isReady', true)
    commit('isLocked', true)
    commit('apiMethod', 'patch')
  },

  updateTermsAgreed ({ commit, state }, { termsAgreed }) {
    commit('termsAgreed', termsAgreed)

    axios.post('/registration/terms_agreement', {
      termsAgreed,
      wizardToken: state.wizardToken,
    }).then(({ data: { data: { attributes } } }) => {
      commit('wizardToken', attributes.wizardToken)
      commit('termsAgreed', attributes.termsAgreed)
      commit('termsAgreedDate', attributes.termsAgreedDate)
      commit('location', attributes)
    }).catch(err => console.error(err))
  },

  saveEmail ({ commit, state }, { email }) {
    axios.post('/registration/email', {
      email: {
        email,
        wizardToken: state.wizardToken,
      }
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

  updateProfileChoice ({ commit, state }, choice) {
    axios.post('/registration/profile_choice', {
      profile_choice: {
        choice,
        wizardToken: state.wizardToken,
      },
    }).then(({ data: { data: { attributes }} }) => {
      commit('profileChoice', attributes.profileChoice)
    }).catch(err => console.error(err))
  },

  updateLocation ({ commit, state }, attrs) {
    const data = Object.assign({}, {
      city: state.city,
      state: state.state,
      country: state.country,
    }, attrs)

    commit('location', data)

    axios.post(`/${state.apiRoot}/location`, {
      location: {
        ...data,
        token: state.token,
      },
    }).then(({ data: { data: { attributes }} }) => {
      commit('location', attributes)
    }).catch(err => console.error(err))
  },

  updateBasicProfile ({ commit, state }, attrs) {
    const data = Object.assign({}, {
      firstName: state.firstName,
      lastName: state.lastName,
      genderIdentity: state.genderIdentity,
      schoolCompanyName: state.schoolCompanyName,
      jobTitle: state.jobTitle,
      mentorType: state.mentorType,
      expertiseIds: state.expertiseIds,
      bio: state.bio,
      referredBy: state.referredBy,
      referredByOther: state.referredByOther,
    }, attrs)

    return axios[state.apiMethod](`/${state.apiRoot}/basic_profile`, {
      basicProfile: {
        ...data,
        wizardToken: state.wizardToken,
      },
    }).catch(err => console.error(err))
  },
}