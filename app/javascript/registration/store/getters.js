export default {
  getTermsAgreed (state) {
    return state.termsAgreed
  },

  getEmail (state) {
    return state.email
  },

  getBirthdate (state) {
    return [state.birthYear, state.birthMonth, state.birthDay].join('-')
  },
}