const digState = (state, key, attribute, conditionFunc) => {
  const data = state[key].data

  if (data) {
    const value = state[key].data.attributes[attribute]
    if (!conditionFunc)
      return value

    return conditionFunc(value)
  } else {
    return undefined
  }
}

export default {
  isBioFilled (state) {
    return digState(state, 'currentMentor', 'bio', bio => bio.length)
  },

  isConsentSigned (state) {
    return digState(state, 'consentWaiver', 'isSigned')
  },

  isBackgroundCheckClear (state) {
    return digState(state, 'backgroundCheck', 'isClear')
  },

  isBackgroundCheckWaived (state) {
    return digState(state, 'currentAccount', 'countryCode', code => code !== 'US')
  },

  isOnTeam (state) {
    return state.currentTeams.length
  },

  backgroundCheckUpdatedAtEpoch (state) {
    return digState(state, 'backgroundCheck', 'updatedAtEpoch')
  },

  consentWaiverSignedAtEpoch (state) {
    return digState(state, 'consentWaiver', 'signedAtEpoch')
  },
}