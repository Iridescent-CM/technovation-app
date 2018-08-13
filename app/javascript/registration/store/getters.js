export default {
  readyForAccount (state, getters) {
    return state.termsAgreed &&
            getters.isAgeSet &&
              getters.isLocationSet &&
                !!state.profileChoice &&
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
    if (state.profileChoice === 'student') {
      return !!(state.firstName &&
                  state.lastName &&
                    state.schoolCompanyName)
    } else {
      return !!(state.firstName &&
                  state.lastName &&
                    state.schoolCompanyName &&
                      state.jobTitle &&
                          state.genderIdentity)
    }
  },

  getBirthdate (state) {
    return [state.birthYear, state.birthMonth, state.birthDay].join('-')
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
}