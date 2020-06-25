import { digStateAttributes } from 'utilities/vuex-utils'

export default {
  currentAccountName (state) {
    return digStateAttributes(state, 'currentAccount', 'name')
  },

  currentAccountAvatarUrl (state) {
    return digStateAttributes(state, 'currentAccount', 'avatarUrl')
  },

  regionalAmbassadorName (state) {
    return digStateAttributes(state, 'regionalAmbassador', 'name')
  },

  regionalProgramName (state) {
    const programName = digStateAttributes(state, 'regionalAmbassador', 'programName')

    if (!programName) {
      return digStateAttributes(state, 'regionalAmbassador', 'name')
    } else {
      return programName
    }
  },

  regionalAmbassadorAvatarUrl (state) {
    return digStateAttributes(state, 'regionalAmbassador', 'avatarUrl')
  },

  regionalAmbassadorHasProvidedIntro (state) {
    return digStateAttributes(state, 'regionalAmbassador', 'hasProvidedIntro')
  },

  canJoinTeams (state) {
    return digStateAttributes(state, 'currentMentor', 'isOnboarded')
  },

  isOnboarded (state) {
    return digStateAttributes(state, 'currentMentor', 'isOnboarded')
  },

  nextOnboardingStep (state) {
    return digStateAttributes(state, 'currentMentor', 'nextOnboardingStep')
  },

  isTrainingComplete (state) {
    return digStateAttributes(state, 'currentMentor', 'isTrainingComplete')
  },

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
    const isCountryUS = digStateAttributes(state, 'currentAccount', 'countryCode', code => code == 'US')
    const isAgeAppropriate = digStateAttributes(state, 'currentAccount', 'age', age => parseInt(age) >= 18)
    return !isCountryUS || !isAgeAppropriate
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

  canDisplayScores (state) {
    return state.settings.canDisplayScores
  },
}
