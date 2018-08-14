import Vue from 'vue'

export default {
  expertiseIds (state, value) {
    Vue.set(state, 'expertiseIds', value)
  },

  isReady (state, bool) {
    state.isReady = bool
  },

  wizardToken (state, wizardToken) {
    state.wizardToken = wizardToken
  },

  termsAgreed (state, termsAgreed) {
    state.termsAgreed = termsAgreed
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
    state.state = attributes.state
    state.country = attributes.country
  },

  basicProfile (state, attributes) {
    state.firstName = attributes.firstName
    state.lastName = attributes.lastName
    state.genderIdentity = attributes.genderIdentity
    state.schoolCompanyName = attributes.schoolCompanyName
    state.jobTitle = attributes.jobTitle
    state.mentorType = attributes.mentorType
    state.expertiseIds = attributes.expertiseIds
    state.referredBy = attributes.referredBy
    state.referredByOther = attributes.referredByOther
  },

  account (state, attributes) {

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

  referredBy (state, value) {
    state.referredBy = value
  },

  referredByOther (state, value) {
    state.referredByOther = value
  },
}