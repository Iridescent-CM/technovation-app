import Vue from 'vue'

function expertiseIds (state, exps) {
  const expertises = exps || []

  const hasNewExpertiseId = expertises.some((expertise) => {
    return !state.expertiseIds.includes(expertise)
  })

  if (hasNewExpertiseId || state.expertiseIds.length !== expertises.length) {
    Vue.set(state, 'expertiseIds', expertises)
  }
}

export default {
  expertiseIds,

  isReady (state, bool) {
    state.isReady = bool
  },

  isLocked (state, bool) {
    state.isLocked = bool
  },

  apiRoot (state, value) {
    state.apiRoot = value
  },

  apiMethod (state, value) {
    state.apiMethod = value
  },

  wizardToken (state, wizardToken) {
    state.wizardToken = wizardToken
  },

  token (state, token) {
    state.token = token
  },

  termsAgreed (state, termsAgreed) {
    state.termsAgreed = termsAgreed
  },

  termsAgreedDate (state, termsAgreedDate) {
    state.termsAgreedDate = termsAgreedDate
  },

  email (state, email) {
    state.email = email
  },

  birthDate (state, attributes) {
    state.birthYear = attributes.year
    state.birthMonth = attributes.month
    state.birthDay = attributes.day

    if (!state.birthYear || !state.birthMonth || !state.birthDay)
      state.profileChoice = null
  },

  birthYear (state, year) {
    state.birthYear = year

    if (!state.birthYear)
      state.profileChoice = null
  },

  birthMonth (state, month) {
    state.birthMonth = month

    if (!state.birthMonth)
      state.profileChoice = null
  },

  birthDay (state, day) {
    state.birthDay = day

    if (!state.birthDay)
      state.profileChoice = null
  },

  profileChoice (state, choice) {
    state.profileChoice = choice
  },

  location (state, attributes) {
    state.city = attributes.city
    state.country = attributes.country

    if (
      attributes.state !== null &&
      typeof attributes.state === "object" &&
      attributes.state.hasOwnProperty('name')
    ) {
      state.state = attributes.state.name
    } else {
      state.state = attributes.state
    }
  },

  basicProfile (state, attributes) {
    state.firstName = attributes.firstName
    state.lastName = attributes.lastName
    state.genderIdentity = attributes.genderIdentity
    state.schoolCompanyName = attributes.schoolCompanyName
    state.jobTitle = attributes.jobTitle
    state.mentorType = attributes.mentorType
    expertiseIds(state, attributes.expertiseIds)
    state.bio = attributes.bio
    state.referredBy = attributes.referredBy
    state.referredByOther = attributes.referredByOther
  },

  firstName (state, value) {
    state.firstName = value
  },

  lastName (state, value) {
    state.lastName = value
  },

  genderIdentity (state, value) {
    state.genderIdentity = value
  },

  schoolCompanyName (state, value) {
    state.schoolCompanyName = value
  },

  jobTitle (state, value) {
    state.jobTitle = value
  },

  mentorType (state, value) {
    state.mentorType = value
  },

  bio (state, value) {
    state.bio = value
  },

  referredBy (state, value) {
    state.referredBy = value
  },

  referredByOther (state, value) {
    state.referredByOther = value
  },
}