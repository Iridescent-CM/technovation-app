<template>
  <div class="tabs tabs--vertical tabs--css-only grid">
    <div class="tabs__content grid__col-9">
      <div class="grid margin--t-xlarge">
        <div class="grid__col-8">
          <router-view :key="$route.name">
            <div slot="events"><slot name="events" /></div>
          </router-view>
        </div>
      </div>
    </div>

    <div class="grid__col-3">
      <div v-sticky-sidebar="stickySidebarClasses">
        <ul class="tabs__menu">
          <tab-link :to="{ name: 'events' }">
            <icon
              :name="completedEnabledOrDisabledIcon(regionalEventCondition)"
              size="16"
              :color="$route.name === 'events' ? '000000' : '28A880'"
            />
            Regional Live Events
          </tab-link>
        </ul>
      </div>
    </div>
  </div>
</template>

<script>
import { mapGetters, mapActions, mapState } from 'vuex'

import Icon from 'components/Icon'
import TabLink from 'tabs/components/TabLink'
import StickySidebar from 'directives/sticky-sidebar'

export default {
  beforeRouteEnter (_to, _from, next) {
    next(vm => {
      // need to check something with vm first?
      next()
    })
  },

  directives: {
    'sticky-sidebar': StickySidebar,
  },

  components: {
    Icon,
    TabLink,
  },

  props: {
    stickySidebarClasses: {
      type: Array,
      default () {
        return []
      },
    },
  },

  computed: {
    ...mapState([]),

    ...mapGetters([]),

    regionalEventCondition () {
      return false
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