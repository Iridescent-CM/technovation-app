import { digStateAttributes, digStateData } from 'utilities/vuex-utils'

export default {
  currentAccountName (state) {
    return digStateAttributes(state, 'currentAccount', 'name')
  },

  currentAccountAvatarUrl (state) {
    return digStateAttributes(state, 'currentAccount', 'avatarUrl')
  },

  chapterAmbassadorName (state) {
    return digStateAttributes(state, 'chapterAmbassador', 'name')
  },

  regionalProgramName (state) {
    const programName = digStateAttributes(state, 'chapterAmbassador', 'programName')

    if (!programName) {
      return digStateAttributes(state, 'chapterAmbassador', 'name')
    } else {
      return programName
    }
  },

  chapterAmbassadorAvatarUrl (state) {
    return digStateAttributes(state, 'chapterAmbassador', 'avatarUrl')
  },

  chapterAmbassadorHasProvidedIntro (state) {
    return digStateAttributes(state, 'chapterAmbassador', 'hasProvidedIntro')
  },

  hasParentalConsent (state) {
    return digStateAttributes(state, 'parentalConsent', 'isSigned')
  },

  parentalConsentSignedAtEpoch (state) {
    return digStateAttributes(state, 'parentalConsent', 'signedAtEpoch')
  },

  hasSavedParentalInfo (state) {
    return digStateAttributes(state, 'currentAccount', 'hasSavedParentalInfo')
  },

  isOnTeam (state) {
    return digStateData(state, 'currentTeam', 'id', id => {
      return !!id && id != '0'
    })
  },

  currentTeamName (state) {
    return digStateAttributes(state, 'currentTeam', 'name')
  },

  currentTeamMentorIds (state) {
    return digStateAttributes(state, 'currentTeam', 'mentorIds') || []
  },

  pendingMentorInviteIds (state) {
    return digStateAttributes(state, 'currentTeam', 'pendingMentorInviteIds') || []
  },

  pendingMentorJoinRequestIds (state) {
    return digStateAttributes(state, 'currentTeam', 'pendingMentorJoinRequestIds') || []
  },

  currentTeamHasMentorsNotPending (_state, getters) {
    return getters.currentTeamMentorIds.length &&
            !getters.pendingMentorInviteIds.length &&
              !getters.pendingMentorJoinRequestIds.length
  },

  submissionComplete (state) {
    return digStateAttributes(state, 'currentSubmission', 'isComplete')
  },

  canDisplayScores (state) {
    return state.settings.canDisplayScores
  },
}
