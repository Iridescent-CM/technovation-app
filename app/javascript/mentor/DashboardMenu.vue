<template>
  <ul class="tabs__menu tabs-menu__parent-menu padding--none">
    <tab-link
      :class="registrationTabLinkClasses"
      :to="{ name: 'basic-profile', meta: { active: registrationPagesActive } }"
      :condition-to-enable="true"
      :condition-to-complete="true"
    >
      Complete your Profile
      <div slot="subnav" class="tabs-menu__child-menu" v-if="registrationPagesActive">
        <registration-menu />
      </div>
    </tab-link>

    <tab-link
      :class="teamTabLinkClasses"
      :to="rootTeamRoute"
      :condition-to-enable="true"
      :condition-to-complete="isConsentSigned && isOnTeam"
    >
      Build your Team
      <div slot="subnav" class="tabs-menu__child-menu" v-if="teamPagesActive">
        <team-menu />
      </div>
    </tab-link>

    <tab-link
      :class="curriculumTabLinkClasses"
      :to="{ name: 'curriculum', meta: { active: curriculumPagesActive } }"
      :condition-to-enable="true"
      :condition-to-complete="submissionComplete"
    >
      Learn from the Curriculum
    </tab-link>

    <tab-link
      :class="submissionTabLinkClasses"
      :to="{ name: 'submission', meta: { active: submissionPagesActive } }"
      :disabled-tooltip="submissionDisabledTooltipMessage"
      :condition-to-enable="isConsentSigned && isOnTeam"
      :condition-to-complete="submissionComplete"
    >Submit your Project</tab-link>

    <tab-link
      :class="eventsTabLinkClasses"
      :to="{ name: 'events', meta: { active: eventsPagesActive } }"
      :disabled-tooltip="tooltips.UNAVAILABLE_DUE_TO_COVID"
      :condition-to-enable="regionalPitchEventsEnabled"
      :condition-to-complete="false"
    >
      Find a Pitch Event
    </tab-link>


    <tab-link
      :class="scoresTabLinkClasses"
      :to="{ name: 'scores', meta: { active: scoresPagesActive } }"
      :disabled-tooltip="tooltips.AVAILABLE_LATER"
      :condition-to-enable="scoresAndCertificatesEnabled"
      :condition-to-complete="false"
    >View Scores & Feedback</tab-link>
  </ul>
</template>

<script>
import { createNamespacedHelpers } from 'vuex'
import menuMixin from 'mixins/menu'
import tooltipsMixin from 'mixins/tooltips'

const { mapGetters } = createNamespacedHelpers('authenticated')

import TabLink from 'tabs/components/TabLink'

import RegistrationMenu from 'registration/DashboardMenu'
import TeamMenu from './menus/Team'

export default {
  name: 'dashboard-menu',

  mixins: [
    menuMixin,
    tooltipsMixin,
  ],

  components: {
    TabLink,
    RegistrationMenu,
    TeamMenu,
  },

  computed: {
    ...mapGetters(['isOnTeam', 'isConsentSigned', 'isOnboarded', 'nextOnboardingStep']),

    rootTeamRoute () {
      if (this.isOnboarded) {
        return { name: 'find-team', meta: { active: this.teamPagesActive } }
      } else {
        return { name: this.nextOnboardingStep, meta: { active: this.teamPagesActive } }
      }
    },

    submissionComplete () {
      return false
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

    curriculumTabLinkClasses () {
      return {
        'tabs__menu-link--active': this.curriculumPagesActive,
      }
    },

    submissionTabLinkClasses () {
      return {
        'tabs__menu-link--active': this.submissionPagesActive,
      }
    },

    eventsTabLinkClasses () {
      return {
        'tabs__menu-link--active': this.eventsPagesActive,
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

    eventsPagesActive () {
      return this.subRouteIsActive('events')
    },

    submissionPagesActive () {
      return this.subRouteIsActive('submission')
    },

    teamPagesActive () {
      return this.subRouteIsActive('team')
    },

    curriculumPagesActive () {
      return this.subRouteIsActive('curriculum')
    },

    registrationPagesActive () {
      return this.subRouteIsActive('registration')
    },

    submissionDisabledTooltipMessage () {
      if (!this.isOnTeam && !this.isConsentSigned)
        return this.tooltips.mentor.submissions.MUST_SIGN_CONSENT_ON_TEAM

      if (!this.isConsentSigned)
        return this.tooltips.mentor.submissions.MUST_SIGN_CONSENT

      return this.tooltips.mentor.submissions.MUST_BE_ON_TEAM
    },
  },
}
</script>
