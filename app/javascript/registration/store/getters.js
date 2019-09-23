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
    return getters.getAge(_state.cutoff)
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
                        state.mentorType &&
                          state.genderIdentity)
    }
  },

  getBirthdate (state) {
    if (
      state.birthMonth !== null &&
      typeof state.birthMonth === 'object' &&
      state.birthMonth.hasOwnProperty('value')
    ) {
      return [state.birthYear, state.birthMonth.value, state.birthDay].join('-')
    } else {
      return [state.birthYear, state.birthMonth, state.birthDay].join('-')
    }
  },

  getLocation (state) {
    return {
      city: state.city,
      state: state.state,
      country: state.country,
    }
  },

  getFullName (state) {
    if (state.firstName || state.lastName)
      return [state.firstName, state.lastName].join(' ')

    return null
  },

  getMonthByValue: (state) => (value) => {
    return state.months.find(month => {
      return month.value == (value || "").toString().replace(/^0/, "")
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