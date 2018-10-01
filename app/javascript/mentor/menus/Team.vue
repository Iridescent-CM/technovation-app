<template>
  <ul class="tabs__menu">
    <tab-link
      :to="{ name: 'mentor-training' }"
      id="mentor_training"
      css-classes="tabs__menu-link--has-subtitles"
      :condition-to-complete="isTrainingComplete"
      :condition-to-enable="true"
    >
      Mentor training
      <span>{{ trainingStatusLabel }}</span>
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
      :to="{ name: 'bio' }"
      css-classes="tabs__menu-link--has-subtitles"
      :condition-to-complete="isBioFilled"
      :condition-to-enable="true"
    >
      Personal summary
      <span>{{ bioLabel }}</span>
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
      :condition-to-enable="canJoinTeams"
    >
      Find your team
      <span>{{ findTeamLabel }}</span>
    </tab-link>

    <tab-link
      :to="{ name: 'create-team' }"
      css-classes="tabs__menu-link--has-subtitles"
      :condition-to-complete="isOnTeam"
      :condition-to-enable="canJoinTeams"
    >
      Create your team
      <span>{{ createTeamLabel }}</span>
    </tab-link>
  </ul>
</template>

<script>
import { createNamespacedHelpers } from 'vuex'

const { mapGetters } = createNamespacedHelpers('authenticated')

import TabLink from 'tabs/components/TabLink'

export default {
  components: {
    TabLink,
  },

  computed: {
    ...mapGetters([
      'isTrainingComplete',
      'isBackgroundCheckClear',
      'isBackgroundCheckWaived',
      'isBioFilled',
      'isOnTeam',
      'isConsentSigned',
      'consentWaiverSignedAtEpoch',
      'backgroundCheckUpdatedAtEpoch',
      'canJoinTeams',
    ]),

    trainingStatusLabel () {
      if (this.isTrainingComplete) {
        return 'You completed training!'
      } else {
        return 'Everything you need to know'
      }
    },

    bioLabel () {
      if (this.isBioFilled) {
        return 'Thank you for your summary!'
      } else {
        return 'Tell us more about yourself'
      }
    },

    consentStatusLabel () {
      if (this.isConsentSigned) {
        return `Signed on ${new Date(this.consentWaiverSignedAtEpoch).toDateString()}`
      } else {
        return 'You must sign the consent waiver to volunteer'
      }
    },

    backgroundCheckStatusLabel () {
      if (this.isBackgroundCheckWaived) {
        return 'Not required at this time'
      } else if (this.isBackgroundCheckClear) {
        return `Cleared on ${new Date(this.backgroundCheckUpdatedAtEpoch).toDateString()}`
      } else {
        return 'You must pass a background check to volunteer'
      }
    },

    findTeamLabel () {
      if (this.isOnTeam) {
        return `You are on a team`
      } else {
        return 'Look for an existing team to join'
      }
    },

    createTeamLabel () {
      if (this.isOnTeam) {
        return `You are on the team`
      } else {
        return 'Form a new team with others'
      }
    },
  },
}
</script>