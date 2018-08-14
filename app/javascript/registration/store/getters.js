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

  getAge: (state) => (compareDate = new Date()) => {
    const year = parseInt(state.birthYear)
    const month = parseInt(Object.assign({}, state.birthMonth).value)
    const day = parseInt(state.birthDay)

    if (!year || !month || !day) return false

    const compareYear = compareDate.getFullYear()
    const compareMonth = compareDate.getMonth() + 1
    const compareDay = compareDate.getDate()

    const extraYear = (
      compareMonth > month ||
        (compareMonth === month && compareDay >= day)
    ) ? 0 : 1

    return compareYear - year - extraYear
  },

  getAgeByCutoff (_state, getters) {
    return getters.getAge(new Date("2019-08-01"))
  },

  isLocationSet (state) {
    return !!state.country
  },

  isProfileChosen (state) {
    return !!state.profileChoice
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