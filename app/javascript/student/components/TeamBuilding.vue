<template>
  <div class="tabs tabs--vertical tabs--css-only grid">
    <ul class="tabs__menu grid__col-3">
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
    </ul>

    <div class="tabs__content grid__col-9">
      <form class="panel panel--contains-bottom-bar panel--contains-top-bar">
        <div class="panel__top-bar">
          Part 2: Team building
        </div>

        <div class="panel__content">
          <router-view></router-view>
        </div>

        <div class="panel__bottom-bar">
          <a
            class="button float--left"
            @click.prevent="navigateBack"
          >
            Back
          </a>
          <button
            class="button"
            :disabled="!nextStepEnabled"
            @click.prevent="handleSubmit"
          >
            Next
          </button>
        </div>
      </form>
    </div>
  </div>
</template>

<script>
import { mapGetters, mapActions, mapState } from 'vuex'

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
    ...mapState([]),

    ...mapGetters([]),

    nextStepEnabled () {
      true
    },

    hasParentalConsent () {
      return true
    },

    isOnTeam () {
      return false
    },
  },

  watch: {
  },

  methods: {
    ...mapActions([]),

    handleSubmit () {
      if (!this.nextStepEnabled) return false
      console.log("[TRIPLE LINDI]", "well? we're waiting...")
    },

    navigateBack () {
      history.back()
    },

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