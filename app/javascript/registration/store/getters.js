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

  getMonthByValue: (state) => (value) => {
    return state.months.find(month => {
      return month.value == (value || "").toString()
    })
  },
}