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
import StickySidebar from 'directives/sticky-sidebar'

export default {
  directives: {
    'sticky-sidebar': StickySidebar,
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
}
</script>

<style lang="scss" scoped>
</style>