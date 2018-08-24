<template>
  <div class="tabs tabs--vertical tabs--css-only grid">
    <div :class="['tabs__content', mainContainerGridColumn]">
      <div class="grid margin--t-xlarge">
        <div class="grid__col-8">
          <router-view :key="$route.name">
            <div slot="events"><slot name="events" /></div>
          </router-view>
        </div>
      </div>
    </div>

    <div class="grid__col-3" v-if="!embedded">
      <div v-sticky-sidebar="stickySidebarClasses">
        <judging-menu />
      </div>
    </div>
  </div>
</template>

<script>
import { mapGetters, mapActions, mapState } from 'vuex'

import StickySidebar from 'directives/sticky-sidebar'

import JudgingMenu from './JudgingMenu'

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
    JudgingMenu,
  },

  props: {
    stickySidebarClasses: {
      type: Array,
      default () {
        return []
      },
    },

    embedded: {
      type: Boolean,
      required: false,
      default: false,
    },
  },

  computed: {
    ...mapState([]),

    ...mapGetters([]),

    mainContainerGridColumn () {
      if (this.embedded)
        return 'grid__col-12'

      return 'grid__col-9'
    },
  },

  watch: {
  },

  methods: {
    ...mapActions([]),
  },
}
</script>

<style lang="scss" scoped>
</style>