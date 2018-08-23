<template>
  <div class="tabs tabs--css-only">
    <div v-sticky-nav>
      <ul class="tabs__menu">
        <tab-link
          :class="scoresTabLinkClasses"
          :to="{ name: 'scores' }"
        >5. Get scores & valuable feedback</tab-link>

        <tab-link
          :class="judgingTabLinkClasses"
          :to="{ name: 'events' }"
        >4. Compete in the judging rounds</tab-link>

        <tab-link
          :class="submissionTabLinkClasses"
          :to="{ name: 'submission' }"
        >3. Submit your project</tab-link>

        <tab-link
          :class="teamTabLinkClasses"
          :to="{ name: 'parental-consent' }"
        >2. Build your team</tab-link>

        <tab-link
          :class="registrationTabLinkClasses"
          :to="{ name: 'basic-profile' }"
        >1. Registration</tab-link>
      </ul>
    </div>

    <div class="tabs__content background-color--white">
      <router-view :key="$route.name">
        <div slot="change-email"><slot name="change-email" /></div>
        <div slot="change-password"><slot name="change-password" /></div>
        <div slot="parental-consent"><slot name="parental-consent" /></div>
        <div slot="find-team"><slot name="find-team" /></div>
        <div slot="create-team"><slot name="create-team" /></div>
        <div slot="find-mentor"><slot name="find-mentor" /></div>
        <div slot="submission"><slot name="submission" /></div>
        <div slot="events"><slot name="events" /></div>
        <div slot="scores"><slot name="scores" /></div>
      </router-view>
    </div>
  </div>
</template>

<script>
import { createNamespacedHelpers } from 'vuex'

import Icon from 'components/Icon'
import TabLink from 'tabs/components/TabLink'
import StickyNav from 'directives/sticky-nav'

const { mapState, mapGetters } = createNamespacedHelpers('student')

export default {
  name: 'app',

  directives: {
    'sticky-nav': StickyNav,
  },

  components: {
    Icon,
    TabLink,
  },

  computed: {
    ...mapState([
    ]),

    ...mapGetters([
    ]),

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
