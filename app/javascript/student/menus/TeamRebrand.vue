<template>
  <ul class="tabs__menu">
    <tab-link
      :to="{ name: 'parental-consent' }"
      css-classes="tabs__menu-link--has-subtitles"
      :condition-to-complete="hasParentalConsent"
      :condition-to-enable="true"
      class="my-4"
    >
      <section class="menu-item-wrapper">
        <span>Parental consent</span>
        <span class="support-text">{{ parentalConsentStatusLabel }}</span>
      </section>
    </tab-link>

    <tab-link
      :to="{ name: 'find-team' }"
      css-classes="tabs__menu-link--has-subtitles"
      :condition-to-complete="isOnTeam"
      :condition-to-enable="true"
      class="my-4"
    >
      <section class="menu-item-wrapper">
        <span>Find your team</span>
        <span class="support-text">{{ findTeamLabel }}</span>
      </section>
    </tab-link>

    <tab-link
      :to="{ name: 'create-team' }"
      css-classes="tabs__menu-link--has-subtitles"
      :condition-to-complete="isOnTeam"
      :condition-to-enable="true"
      class="my-4"
    >
      <section class="menu-item-wrapper">
        <span>Create your team</span>
        <span class="support-text">{{ createTeamLabel }}</span>
      </section>
    </tab-link>

    <tab-link
      :to="{ name: 'find-mentor' }"
      css-classes="tabs__menu-link--has-subtitles"
      :condition-to-complete="currentTeamHasMentorsNotPending"
      :condition-to-enable="true"
      class="my-4"
    >
      <section class="menu-item-wrapper">
        <span>Add a mentor to your team</span>
        <span class="support-text">{{ findMentorLabel }}</span>
      </section>
    </tab-link>
  </ul>
</template>

<script>
import { createNamespacedHelpers } from 'vuex'

const { mapGetters } = createNamespacedHelpers('authenticated')

import TabLink from 'tabs/components/TabLinkRebrand'

export default {
  components: {
    TabLink,
  },

  computed: {
    ...mapGetters([
      'hasParentalConsent',
      'parentalConsentSignedAtEpoch',
      'hasSavedParentalInfo',
      'isOnTeam',
      'currentTeamName',
      'currentTeamHasMentorsNotPending',
      'currentTeamMentorIds',
      'pendingMentorInviteIds',
      'pendingMentorJoinRequestIds',
    ]),

    parentalConsentStatusLabel () {
      if (this.hasParentalConsent) {
        return `Signed on ${new Date(this.parentalConsentSignedAtEpoch).toDateString()}`
      } else if (this.hasSavedParentalInfo) {
        return 'Waiting for parent to check email, sign form'
      } else {
        return 'You must get permission to compete'
      }
    },

    findTeamLabel () {
      if (this.isOnTeam) {
        return `You are on the team ${this.currentTeamName}`
      } else {
        return 'Look for an existing team to join'
      }
    },

    createTeamLabel () {
      if (this.isOnTeam) {
        return `You are on the team ${this.currentTeamName}`
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
      } else if (this.currentTeamMentorIds.length) {
        return 'Your team has at least one mentor'
      } else {
        return 'Find a mentor for your team!'
      }
    },
  },
}
</script>