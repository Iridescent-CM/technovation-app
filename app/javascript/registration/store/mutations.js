export default {
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
  },

  birthYear (state, year) {
    state.birthYear = year
  },

  birthMonth (state, month) {
    state.birthMonth = month
  },

  birthDay (state, day) {
    state.birthDay = day
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

  referredBy (state, value) {
    state.referredBy = value
  },

  referredByOther (state, value) {
    state.referredByOther = value
  },
}