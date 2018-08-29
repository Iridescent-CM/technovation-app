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
    ...mapState(['currentTeam', 'parentalConsent']),

    hasParentalConsent () {
      return !!this.parentalConsent && this.parentalConsent.isSigned
    },

    isOnTeam () {
      return this.currentTeam && !!this.currentTeam.id
    },

    mentorNotPending () {
      return this.currentTeam &&
        this.currentTeam.mentorIds &&
          this.currentTeam.mentorIds.length &&
            !this.currentTeam.pendingMentorInviteIds ||
              !this.currentTeam.pendingMentorInviteIds.length &&
                !this.currentTeam.pendingMentorJoinRequestIds.length
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