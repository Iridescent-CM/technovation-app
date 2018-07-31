export default {
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
}