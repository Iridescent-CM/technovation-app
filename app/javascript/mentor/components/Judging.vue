<template>
  <div :class="['tabs', 'tabs--vertical', 'tabs--css-only', mainTabsGridCss]">
    <div :class="['tabs__content', mainContainerGridColumn]">
      <router-view :key="$route.name">
        <div slot="events"><slot name="events" /></div>
      </router-view>
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

import JudgingMenu from 'student/menus/Judging'

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

    mainTabsGridCss () {
      if (this.embedded)
        return ''

      return 'grid'
    },

    mainContainerGridColumn () {
      if (this.embedded)
        return 'tabs__content--embedded'

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