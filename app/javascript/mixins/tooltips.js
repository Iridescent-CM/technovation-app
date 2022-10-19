const Tooltips = {
  mentor: {
    submissions: {
      MUST_SIGN_CONSENT_ON_TEAM: 'You must be on a team and sign a consent waiver to work on submissions',
      MUST_SIGN_CONSENT: 'You must sign a consent waiver to work on submissions',
      MUST_BE_ON_TEAM: 'You must be on a team to work on submissions',
    },
  },

  student: {
    submissions: {
      MUST_HAVE_PERMISSION_ON_TEAM: 'You must be on a team and have parental consent to work on your submission',
      MUST_HAVE_PERMISSION: 'You must have parental consent to work on your submission',
      MUST_BE_ON_TEAM: 'You must be on a team to work on your submission',
    }
  },

  REGIONAL_PITCH_EVENTS_AVAILABLE_LATER: 'This feature will open later in the season if your local chapter is hosting an event.',
  SCORES_AND_CERTIFICATES_AVAILABLE_LATER: 'This feature will open later in the season.'
}

export default {
  created () {
    this.tooltips = Tooltips
  },
}
