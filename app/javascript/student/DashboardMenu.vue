
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
      :condition-to-complete="hasParentalConsent && isOnTeam"
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
      :condition-to-enable="hasParentalConsent && isOnTeam"
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
import menuMixin from 'mixins/menu'

const { mapGetters } = createNamespacedHelpers('authenticated')

import TabLink from 'tabs/components/TabLink'

import RegistrationMenu from 'registration/DashboardMenu'
import JudgingMenu from './menus/Judging'
import TeamMenu from './menus/Team'

const Tooltips = {
  MUST_HAVE_PERMISSION_ON_TEAM: 'You must be on a team and have parental consent to work on your submission',
  MUST_HAVE_PERMISSION: 'You must have parental consent to work on your submission',
  MUST_BE_ON_TEAM: 'You must be on a team to work on your submission',
  AVAILABLE_LATER: 'This feature will open later in the Season',
}

export default {
  name: 'dashboard-menu',

  mixins: [
    menuMixin,
  ],

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
    ...mapGetters(['isOnTeam', 'submissionComplete', 'hasParentalConsent']),

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
}
</script>