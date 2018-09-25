<template>
  <div class="tabs tabs--vertical tabs--css-only grid">
    <div :class="['tabs__content', mainContainerGridColumn]">
      <router-view :key="$route.name">
        <div slot="parental-consent"><slot name="parental-consent" /></div>
        <div slot="find-team"><slot name="find-team" /></div>
        <div slot="create-team"><slot name="create-team" /></div>
        <div slot="find-mentor"><slot name="find-mentor" /></div>
      </router-view>
    </div>

    <div class="grid__col-3" v-if="!embedded">
      <div class="tabs-menu__child-menu" v-sticky-sidebar="stickySidebarClasses">
        <team-menu />
      </div>
    </div>
  </div>
</template>

<script>
import StickySidebar from 'directives/sticky-sidebar'
import TeamMenu from 'student/menus/Team'

export default {
  name: 'team-building',

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
    mainContainerGridColumn () {
      if (this.embedded)
        return 'grid__col-12 tabs__content--embedded'

      return 'grid__col-9'
    },
  },
}
</script>