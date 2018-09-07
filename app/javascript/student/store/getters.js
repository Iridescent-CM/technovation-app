import { digStateAttributes, digStateData } from 'utilities/vuex-utils'

export default {
  currentAccountName (state) {
    return digStateAttributes(state, 'currentAccount', 'name')
  },

  hasParentalConsent (state) {
    return digStateAttributes(state, 'parentalConsent', 'isSigned')
  },

  hasSavedParentalInfo (state) {
    return digStateAttributes(state, 'currentAccount', 'hasSavedParentalInfo')
  },

  isOnTeam (state) {
    return digStateData(state, 'currentTeam', 'id', id => !!id)
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
    return digStateAttributes(state, 'submission', 'isComplete')
  },
}