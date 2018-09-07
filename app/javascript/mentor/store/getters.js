import { digStateAttributes } from 'utilities/vuex-utils'

export default {
  isBioFilled (state) {
    return digStateAttributes(state, 'currentMentor', 'bio', bio => bio.length)
  },

  isConsentSigned (state) {
    return digStateAttributes(state, 'consentWaiver', 'isSigned')
  },

  isBackgroundCheckClear (state) {
    return digStateAttributes(state, 'backgroundCheck', 'isClear')
  },

  isBackgroundCheckWaived (state) {
    return digStateAttributes(state, 'currentAccount', 'countryCode', code => code !== 'US')
  },

  isOnTeam (state) {
    return state.currentTeams.length
  },

  backgroundCheckUpdatedAtEpoch (state) {
    return digStateAttributes(state, 'backgroundCheck', 'updatedAtEpoch')
  },

  consentWaiverSignedAtEpoch (state) {
    return digStateAttributes(state, 'consentWaiver', 'signedAtEpoch')
  },
}