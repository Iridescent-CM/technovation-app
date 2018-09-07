const digStateType = (state, key) => {
  if (state[key]) {
    return state[key].type
  } else {
    return undefined
  }
}

const digStateData = (state, key, property, conditionFunc) => {
  const data = state[key].data

  if (data) {
    const value = state[key].data[property]
    if (value) {
      if (!conditionFunc)
        return value

      return conditionFunc(value)
    } else {
      return undefined
    }
  } else {
    return undefined
  }
}

const digStateAttributes  = (state, key, attribute, conditionFunc) => {
  const attributes = digStateData(state, key, 'attributes')

  if (attributes) {
    const value = attributes[attribute]
    if (!conditionFunc)
      return value

    return conditionFunc(value)
  } else {
    return undefined
  }
}

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
}