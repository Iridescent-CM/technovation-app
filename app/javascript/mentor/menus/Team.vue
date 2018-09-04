<template>
  <ul class="tabs__menu">
    <tab-link
      :to="{ name: 'bio' }"
      css-classes="tabs__menu-link--has-subtitles"
      :condition-to-complete="isBioFilled"
      :condition-to-enable="true"
    >
      Personal summary
      <span>{{ bioLabel }}</span>
    </tab-link>

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
      :to="{ name: 'background-check' }"
      css-classes="tabs__menu-link--has-subtitles"
      :condition-to-complete="isBackgroundCheckWaived || isBackgroundCheckClear"
      :condition-to-enable="true"
    >
      Background Check
      <span>{{ backgroundCheckStatusLabel }}</span>
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

const { mapState } = createNamespacedHelpers('authenticated')

import TabLink from 'tabs/components/TabLink'

export default {
  components: {
    TabLink,
  },

  computed: {
    ...mapState(['currentAccount', 'currentMentor', 'currentTeams', 'consentWaiver']),

    isBioFilled () {
      return !!this.currentMentor.bio && this.currentMentor.bio.length
    },

    isConsentSigned () {
      return !!this.consentWaiver && this.consentWaiver.isSigned
    },

    isBackgroundCheckWaived () {
      return this.currentAccount.countryCode != 'US'
    },

    isBackgroundCheckClear () {
      return !!this.backgroundCheck.isClear
    },

    consentStatusLabel () {
      if (this.isConsentSigned) {
        return `Signed on ${new Date(this.consentWaiver.signedAtEpoch).toDateString()}`
      } else {
        return 'You must sign the consent waiver to volunteer'
      }
    },

    backgroundCheckStatusLabel () {
      if (this.isBackgroundCheckWaived) {
        return 'Not required at this time'
      } else if (this.isBackgroundCheckClear) {
        return `Cleared on ${new Date(this.backgrouncCheck.updatedAtEpoch).toDateString()}`
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