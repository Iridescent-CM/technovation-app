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

  AVAILABLE_LATER: 'This feature will open later in the Season',
}

export default {
  created () {
    this.tooltips = Tooltips
  },
}
