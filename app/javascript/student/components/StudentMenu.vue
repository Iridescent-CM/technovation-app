
<template>
  <ul class="tabs__menu tabs-menu__parent-menu padding--none">
    <tab-link
      :class="registrationTabLinkClasses"
      :to="{ name: 'basic-profile', meta: { active: registrationPagesActive } }"
      :condition-to-enable="true"
      :condition-to-complete="true"
    >
      Registration
      <div slot="subnav" class="tabs-menu__child-menu" v-if="registrationPagesActive">
        <registration-menu />
      </div>
    </tab-link>

    <tab-link
      :class="teamTabLinkClasses"
      :to="{ name: 'parental-consent', meta: { active: teamPagesActive } }"
      :condition-to-enable="true"
      :condition-to-complete="consentSigned && isOnTeam"
    >
      Build your team
      <div slot="subnav" class="tabs-menu__child-menu" v-if="teamPagesActive">
        <team-menu />
      </div>
    </tab-link>

    <tab-link
      :class="submissionTabLinkClasses"
      :to="{ name: 'submission', meta: { active: submissionPagesActive } }"
      :disabled-tooltip="submissionDisabledTooltipMessage"
      :condition-to-enable="consentSigned && isOnTeam"
      :condition-to-complete="submissionComplete"
    >Submit your project</tab-link>

    <tab-link
      :class="judgingTabLinkClasses"
      :to="{ name: 'events', meta: { active: judgingPagesActive } }"
      :disabled-tooltip="Tooltips.AVAILABLE_LATER"
      :condition-to-enable="false"
      :condition-to-complete="false"
    >
      Compete
      <div slot="subnav" class="tabs-menu__child-menu" v-if="judgingPagesActive">
        <judging-menu />
      </div>
    </tab-link>


    <tab-link
      :class="scoresTabLinkClasses"
      :to="{ name: 'scores', meta: { active: scoresPagesActive } }"
      :disabled-tooltip="Tooltips.AVAILABLE_LATER"
      :condition-to-enable="false"
      :condition-to-complete="false"
    >Scores & Feedback</tab-link>
  </ul>
</template>

<script>
import { createNamespacedHelpers } from 'vuex'

const { mapState } = createNamespacedHelpers('student')

import TabLink from 'tabs/components/TabLink'

import RegistrationMenu from 'registration/components/RegistrationMenu'
import JudgingMenu from './JudgingMenu'
import TeamMenu from './TeamMenu'

const Tooltips = {
  MUST_HAVE_PERMISSION_ON_TEAM: 'You must be on a team and have parental consent to work on your submission',
  MUST_HAVE_PERMISSION: 'You must have parental consent to work on your submission',
  MUST_BE_ON_TEAM: 'You must be on a team to work on your submission',
  AVAILABLE_LATER: 'This feature will open later in the Season',
}

export default {
  components: {
    TabLink,
    RegistrationMenu,
    TeamMenu,
    JudgingMenu,
  },

  created () {
    this.Tooltips = Tooltips
  },

  computed: {
    ...mapState(['currentTeam', 'parentalConsent', 'submission']),

    consentSigned () {
      return !!this.parentalConsent.isSigned
    },

    isOnTeam () {
      return !!this.currentTeam.id
    },

    submissionComplete () {
      return !!this.submission.isComplete
    },

    registrationTabLinkClasses () {
      return {
        'tabs__menu-link--active': this.registrationPagesActive,
      }
    },

    teamTabLinkClasses () {
      return {
        'tabs__menu-link--active': this.teamPagesActive,
      }
    },

    submissionTabLinkClasses () {
      return {
        'tabs__menu-link--active': this.submissionPagesActive,
      }
    },

    judgingTabLinkClasses () {
      return {
        'tabs__menu-link--active': this.judgingPagesActive,
      }
    },

    scoresTabLinkClasses () {
      return {
        'tabs__menu-link--active': this.scoresPagesActive,
      }
    },

    scoresPagesActive () {
      return this.subRouteIsActive('scores')
    },

    judgingPagesActive () {
      return this.subRouteIsActive('judging')
    },

    submissionPagesActive () {
      return this.subRouteIsActive('submission')
    },

    teamPagesActive () {
      return this.subRouteIsActive('team')
    },

    registrationPagesActive () {
      return this.subRouteIsActive('registration')
    },

    submissionDisabledTooltipMessage () {
      if (!this.isOnTeam && !this.consentSigned)
        return Tooltips.MUST_HAVE_PERMISSION_ON_TEAM

      if (!this.consentSigned)
        return Tooltips.MUST_HAVE_PERMISSION

      return Tooltips.MUST_BE_ON_TEAM
    },
  },

  methods: {
    subRouteIsActive(parentRouteId) {
      const parentRoute = this.$router.options.routes.find((parentRoute) => {
        if (Object.prototype.hasOwnProperty.call(parentRoute, 'children')) {
          return parentRoute.children.some((childRoute) => {
            return this.$route.name === childRoute.name
          })
        }

        return false
      })

      if (
        parentRoute &&
        Object.prototype.hasOwnProperty.call(parentRoute, 'meta') &&
        Object.prototype.hasOwnProperty.call(parentRoute.meta, 'routeId')
      ) {
        return parentRouteId === parentRoute.meta.routeId
      }

      return false
    },
  },
}
</script>