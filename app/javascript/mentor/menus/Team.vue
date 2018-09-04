<template>
  <ul class="tabs__menu">
    <tab-link
      :to="{ name: 'consent-waiver' }"
      css-classes="tabs__menu-link--has-subtitles"
      :condition-to-complete="isConsentSigned"
      :condition-to-enable="true"
    >
      Consent Waiver
      <span>{{ consentStatusLabel }}</span>
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
  </ul>
</template>

<script>
import { createNamespacedHelpers } from 'vuex'

const { mapState } = createNamespacedHelpers('mentor')

import TabLink from 'tabs/components/TabLink'

export default {
  components: {
    TabLink,
  },

  computed: {
    ...mapState(['currentAccount', 'currentTeams', 'consentWaiver']),

    isConsentSigned () {
      return !!this.consentWaiver && this.consentWaiver.isSigned
    },

    consentStatusLabel () {
      if (this.isConsentSigned) {
        return `Signed on ${new Date(this.consentWaiver.signedAtEpoch).toDateString()}`
      } else {
        return 'You must sign the consent waiver to volunteer'
      }
    },

    findTeamLabel () {
      if (this.isOnTeam) {
        return `You are on the team ${this.currentTeams[0].name}`
      } else {
        return 'Look for an existing team to join'
      }
    },

    createTeamLabel () {
      if (this.isOnTeam) {
        return `You are on the team ${this.currentTeams[0].name}`
      } else {
        return 'Form a new team with others'
      }
    },

    isOnTeam () {
      return this.currentTeams.length
    },
  },
}
</script>