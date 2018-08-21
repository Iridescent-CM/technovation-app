<template>
  <div class="tabs tabs--vertical tabs--css-only grid">
    <div class="grid__col-3 col--sticky-parent">
      <div class="col--sticky-spacer">
        <ul class="tabs__menu col--sticky">
          <tab-link :to="{ name: 'parental-consent' }">
            <icon
              :name="completedEnabledOrDisabledIcon(hasParentalConsent)"
              size="16"
              :color="$route.name === 'parental-consent' ? '000000' : '28A880'"
            />
            Parental Consent
          </tab-link>

          <tab-link :to="{ name: 'find-team' }">
            <icon
              :name="completedEnabledOrDisabledIcon(isOnTeam)"
              size="16"
              :color="$route.name === 'parental-consent' ? '000000' : '28A880'"
            />
            Find your team
          </tab-link>

          <tab-link :to="{ name: 'create-team' }">
            <icon
              :name="completedEnabledOrDisabledIcon(isOnTeam)"
              size="16"
              :color="$route.name === 'parental-consent' ? '000000' : '28A880'"
            />
            Create your team
          </tab-link>

          <tab-link :to="{ name: 'find-mentor' }">
            <icon
              :name="completedEnabledOrDisabledIcon(hasMentor)"
              size="16"
              :color="$route.name === 'find-mentor' ? '000000' : '28A880'"
            />
            Add a mentor to your team
          </tab-link>
        </ul>
      </div>
    </div>

    <div class="tabs__content grid__col-9">
      <div class="grid margin--t-xlarge">
        <div class="grid__col-8">
          <router-view :key="$route.name">
            <div slot="parental-consent"><slot name="parental-consent" /></div>
            <div slot="find-team"><slot name="find-team" /></div>
            <div slot="create-team"><slot name="create-team" /></div>
            <div slot="find-mentor"><slot name="find-mentor" /></div>
          </router-view>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { createNamespacedHelpers } from 'vuex'

const { mapState, mapActions, mapGetters } = createNamespacedHelpers('student')


import Icon from 'components/Icon'
import TabLink from 'tabs/components/TabLink'

export default {
  beforeRouteEnter (_to, _from, next) {
    next(vm => {
      // need to check something with vm first?
      next()
    })
  },

  components: {
    Icon,
    TabLink,
  },

  computed: {
    ...mapState({
      currentTeam: state => state.currentTeam,
    }),

    ...mapGetters([]),

    hasParentalConsent () {
      return true
    },

    isOnTeam () {
      return this.currentTeam && this.currentTeam.id !== null
    },

    hasMentor () {
      return this.currentTeam && this.currentTeam.mentorIds.length
    },
  },

  watch: {
  },

  methods: {
    ...mapActions([]),

    completedEnabledOrDisabledIcon (conditionToComplete) {
      if (conditionToComplete)
        return 'check-circle'

      return 'circle-o'
    },
  },
}
</script>

<style lang="scss" scoped>
</style>