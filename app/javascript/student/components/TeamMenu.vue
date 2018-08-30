<template>
  <ul class="tabs__menu">
    <tab-link
      :to="{ name: 'parental-consent' }"
      css-classes="tabs__menu-link--has-subtitles"
      :condition-to-complete="hasParentalConsent"
      :condition-to-enable="true"
    >
      Parental Consent
      <span>{{ parentalConsentStatusLabel }}</span>
    </tab-link>

    <tab-link
      :to="{ name: 'find-team' }"
      css-classes="tabs__menu-link--has-subtitles"
      :condition-to-complete="isOnTeam"
      :condition-to-enable="true"
    >
      Find your team
      <span>{{ findTeamLabel }}</span>
    </tab-link>

    <tab-link
      :to="{ name: 'create-team' }"
      css-classes="tabs__menu-link--has-subtitles"
      :condition-to-complete="isOnTeam"
      :condition-to-enable="true"
    >
      Create your team
      <span>{{ createTeamLabel }}</span>
    </tab-link>

    <tab-link
      :to="{ name: 'find-mentor' }"
      css-classes="tabs__menu-link--has-subtitles"
      :condition-to-complete="mentorNotPending"
      :condition-to-enable="true"
    >
      Add a mentor to your team
      <span>{{ findMentorLabel }}</span>
    </tab-link>
  </ul>
</template>

<script>
import { createNamespacedHelpers } from 'vuex'

const { mapState } = createNamespacedHelpers('student')

import TabLink from 'tabs/components/TabLink'

export default {
  components: {
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
}
</script>