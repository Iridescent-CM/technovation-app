
<template>
  <ul class="tabs__menu tabs-menu__parent-menu padding--none">
    <tab-link
      :class="registrationTabLinkClasses"
      :to="{ name: 'basic-profile' }"
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
      :to="{ name: 'parental-consent' }"
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
      :to="{ name: 'submission' }"
      :condition-to-enable="true"
      :condition-to-complete="submissionComplete"
    >Submit your project</tab-link>

    <tab-link
      :class="judgingTabLinkClasses"
      :to="{ name: 'events' }"
    >
      Compete
      <div slot="subnav" class="tabs-menu__child-menu" v-if="judgingPagesActive">
        <judging-menu />
      </div>
    </tab-link>


    <tab-link
      :class="scoresTabLinkClasses"
      :to="{ name: 'scores' }"
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

export default {
  components: {
    TabLink,
    RegistrationMenu,
    TeamMenu,
    JudgingMenu,
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
        'tabs__menu-link--active': this.subRouteIsActive('registration'),
      }
    },

    teamTabLinkClasses () {
      return {
        'tabs__menu-link--active': this.subRouteIsActive('team'),
      }
    },

    submissionTabLinkClasses () {
      return {
        'tabs__menu-link--active': this.subRouteIsActive('submission'),
      }
    },

    judgingTabLinkClasses () {
      return {
        'tabs__menu-link--active': this.subRouteIsActive('judging'),
      }
    },

    scoresTabLinkClasses () {
      return {
        'tabs__menu-link--active': this.subRouteIsActive('scores'),
      }
    },

    judgingPagesActive () {
      return this.subRouteIsActive('judging')
    },

    teamPagesActive () {
      return this.subRouteIsActive('team')
    },

    registrationPagesActive () {
      return this.subRouteIsActive('registration')
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