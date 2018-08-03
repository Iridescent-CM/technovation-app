export default {
  getTermsAgreed (state) {
    return state.termsAgreed
  },

  readyForAccount (state, getters) {
    return state.termsAgreed &&
            getters.isAgeSet &&
              getters.isLocationSet &&
                getters.isBasicProfileSet
  },

  isAgeSet (state) {
    return !!(state.birthYear &&
                state.birthMonth &&
                  state.birthDay)
  },

  isLocationSet (state) {
    return !!state.country
  },

  isBasicProfileSet (state) {
    return !!(state.firstName &&
                state.lastName &&
                  state.schoolCompanyName)
  },

  getEmail (state) {
    return state.email
  },

  getBirthdate (state) {
    return [state.birthYear, state.birthMonth, state.birthDay].join('-')
  },

  getProfileChoice (state) {
    return state.profileChoice
  },

  getLocation (state) {
    return {
      city: state.city,
      state: state.state,
      country: state.country,
    }
  },

  getMonthByValue: (state) => (value) => {
    return state.months.find(month => {
      return month.value == (value || "").toString()
    }) || ''
  },

  getBirthdateAttributes: (_state, getters) => (attributes) => {
    return {
      year: attributes.birthYear,
      day: attributes.birthDay,
      month: getters.getMonthByValue(attributes.birthMonth),
    }
  },

  getFirstName (state) {
    return state.firstName
  },

  getLastName (state) {
    return state.lastName
  },

  getGenderIdentity (state) {
    return state.genderIdentity
  },

  getSchoolCompanyName (state) {
    return state.schoolCompanyName
  },

  getReferredBy (state) {
    return state.referredBy
  },

  getReferredByOther (state) {
    return state.referredByOther
  },
}