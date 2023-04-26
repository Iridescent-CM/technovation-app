<template>
  <ul>
<!--    <tab-link-->
<!--      :class="registrationTabLinkClasses"-->
<!--      :to="{ name: 'basic-profile', meta: { active: registrationPagesActive } }"-->
<!--      :condition-to-enable="true"-->
<!--      :condition-to-complete="true"-->
<!--    >-->
<!--      Complete your Profile-->
<!--      <div slot="subnav" class="tabs-menu__child-menu" v-if="registrationPagesActive">-->
<!--        <registration-menu />-->
<!--      </div>-->
<!--    </tab-link>-->

    <tab-link
      :class="teamTabLinkClasses"
      :to="{ name: 'parental-consent', meta: { active: teamPagesActive } }"
      :condition-to-enable="true"
      :condition-to-complete="hasParentalConsent && isOnTeam"
    >
      <span class="btn-text-space">Build your team</span>
      <div slot="subnav" class="tabs-menu__child-menu ml-8" v-if="teamPagesActive">
        <team-menu />
      </div>
    </tab-link>

    <li><hr class="todo-menu-hr"></li>

    <tab-link
      :class="curriculumTabLinkClasses"
      :to="{ name: 'curriculum', meta: { active: curriculumPagesActive } }"
      :condition-to-enable="true"
      :condition-to-complete="submissionComplete"
    >
      <span class="btn-text-space">Learn from the curriculum</span>
    </tab-link>

    <li><hr class="todo-menu-hr"></li>

    <tab-link
      :class="submissionTabLinkClasses"
      :to="{ name: 'submission', meta: { active: submissionPagesActive } }"
      :disabled-tooltip="submissionDisabledTooltipMessage"
      :condition-to-enable="hasParentalConsent && isOnTeam"
      :condition-to-complete="submissionComplete"
    >
      <span class="btn-text-space">Submit your project</span>
    </tab-link>

    <li><hr class="todo-menu-hr"></li>

    <tab-link
      :class="eventsTabLinkClasses"
      :to="{ name: 'events', meta: { active: eventsPagesActive } }"
      :disabled-tooltip="tooltips.REGIONAL_PITCH_EVENTS_AVAILABLE_LATER"
      :condition-to-enable="regionalPitchEventsEnabled"
      :condition-to-complete="false"
    >
      <span class="btn-text-space">Pitch your project</span>

    </tab-link>

    <li><hr class="todo-menu-hr"></li>

    <li>
      <div class="w-full text-left">
        <button class="flex">
            <icon
              name="circle-o"
              size="16"
              color="000000"
              class="mt-1.5"
            />

            <a href="scores/">
              <span class="btn-text-space">Find your scores & certificates</span>
            </a>
        </button>
      </div>
    </li>
  </ul>
</template>

<script>
import { createNamespacedHelpers } from 'vuex'
import menuMixin from 'mixins/menu'
import tooltipsMixin from 'mixins/tooltips'

import Icon from 'components/Icon'

const { mapGetters } = createNamespacedHelpers('authenticated')

import TabLink from 'tabs/components/TabLinkRebrand'

import RegistrationMenu from 'registration/DashboardMenu'
import TeamMenu from './menus/TeamRebrand'

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
    Icon
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
      if (!this.isOnTeam && !this.consentSigned)
        return this.tooltips.student.submissions.MUST_HAVE_PERMISSION_ON_TEAM

      if (!this.consentSigned)
        return this.tooltips.student.submissions.MUST_HAVE_PERMISSION

      return this.tooltips.student.submissions.MUST_BE_ON_TEAM
    },
  },
}
</script>
