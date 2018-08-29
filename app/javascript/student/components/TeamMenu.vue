<template>
  <ul class="tabs__menu">
    <tab-link
      :to="{ name: 'parental-consent' }"
      css-classes="tabs__menu-link--has-subtitles"
    >
      <icon
        :name="completedEnabledOrDisabledIcon(hasParentalConsent)"
        size="16"
        :color="$route.name === 'parental-consent' ? '000000' : '28A880'"
      />
      Parental Consent
      <span>{{ parentalConsentStatusLabel }}</span>
    </tab-link>

    <tab-link
      :to="{ name: 'find-team' }"
      css-classes="tabs__menu-link--has-subtitles"
    >
      <icon
        :name="completedEnabledOrDisabledIcon(isOnTeam)"
        size="16"
        :color="$route.name === 'find-team' ? '000000' : '28A880'"
      />
      Find your team
      <span>{{ findTeamLabel }}</span>
    </tab-link>

    <tab-link
      :to="{ name: 'create-team' }"
      css-classes="tabs__menu-link--has-subtitles"
    >
      <icon
        :name="completedEnabledOrDisabledIcon(isOnTeam)"
        size="16"
        :color="$route.name === 'create-team' ? '000000' : '28A880'"
      />
      Create your team
      <span>{{ createTeamLabel }}</span>
    </tab-link>

    <tab-link
      :to="{ name: 'find-mentor' }"
      css-classes="tabs__menu-link--has-subtitles"
    >
      <icon
        :name="completedEnabledOrDisabledIcon(mentorNotPending)"
        size="16"
        :color="$route.name === 'find-mentor' ? '000000' : '28A880'"
      />
      Add a mentor to your team
      <span>{{ findMentorLabel }}</span>
    </tab-link>
  </ul>
</template>

<script>
import { createNamespacedHelpers } from 'vuex'

const { mapState } = createNamespacedHelpers('student')

import Icon from 'components/Icon'
import TabLink from 'tabs/components/TabLink'

export default {
  components: {
    Icon,
    TabLink,
  },

  computed: {
    ...mapState(['currentAccount', 'currentTeam', 'parentalConsent']),

    hasParentalConsent () {
      return !!this.parentalConsent && this.parentalConsent.isSigned
    },

    parentalConsentStatusLabel () {
      if (this.hasParentalConsent) {
        return `Signed on ${new Date(this.parentalConsent.signedAtEpoch).toDateString()}`
      } else if (this.hasSavedParentalInfo) {
        return 'Waiting for parent to check email, sign form'
      } else {
        return 'You must get permission to compete'
      }
    },

    hasSavedParentalInfo () {
      return this.currentAccount.hasSavedParentalInfo
    },

    findTeamLabel () {
      if (this.isOnTeam) {
        return `You are on the team ${this.currentTeam.name}`
      } else {
        return 'Look for an existing team to join'
      }
    },

    createTeamLabel () {
      if (this.isOnTeam) {
        return `You are on the team ${this.currentTeam.name}`
      } else {
        return 'Form a new team with others'
      }
    },

    findMentorLabel () {
      if (!this.isOnTeam) {
        return 'You need to be on a team first'
      } else if (this.pendingMentorInviteIds.length) {
        return 'You are waiting for mentors to respond to your invites'
      } else if (this.pendingMentorJoinRequestIds.length) {
        return 'Mentors are waiting for your team to respond!'
      } else if (this.mentorIds.length) {
        return 'Your team has at least one mentor'
      } else {
        return 'Find a mentor for your team!'
      }
    },

    isOnTeam () {
      return this.currentTeam && !!this.currentTeam.id
    },

    mentorNotPending () {
      return this.mentorIds.length &&
              !this.pendingMentorInviteIds.length &&
                  !this.pendingMentorJoinRequestIds.length
    },

    pendingMentorInviteIds () {
      return (this.currentTeam && this.currentTeam.pendingMentorInviteIds) || []
    },

    pendingMentorJoinRequestIds () {
      return (this.currentTeam && this.currentTeam.pendingMentorJoinRequestIds) || []
    },

    mentorIds () {
      return (this.currentTeam && this.currentTeam.mentorIds) || []
    },
  },

  methods: {
    completedEnabledOrDisabledIcon (conditionToComplete) {
      if (conditionToComplete)
        return 'check-circle'

      return 'circle-o'
    },
  },
}
</script>