<template>
  <div class="tabs tabs--vertical tabs--css-only grid">
    <div :class="['tabs__content', mainContainerGridColumn]">
      <router-view :key="$route.name">
        <div slot="mentor-training"><slot name="mentor-training" /></div>
        <div slot="bio"><slot name="bio" /></div>
        <div slot="consent-waiver"><slot name="consent-waiver" /></div>
        <div slot="background-check"><slot name="background-check" /></div>
        <div slot="find-team"><slot name="find-team" /></div>
        <div slot="create-team"><slot name="create-team" /></div>
      </router-view>
    </div>

    <div v-if="!embedded" class="grid__col-3">
      <div
        v-sticky-sidebar="stickySidebarClasses"
        class="tabs-menu__child-menu"
      >
        <team-menu />
      </div>
    </div>
  </div>
</template>

<script>
import StickySidebar from "directives/sticky-sidebar";
import TeamMenu from "mentor/menus/Team";

export default {
  name: "TeamBuilding",

  directives: {
    "sticky-sidebar": StickySidebar,
  },

  components: {
    TeamMenu,
  },

  props: {
    stickySidebarClasses: {
      type: Array,
      default() {
        return [];
      },
    },

    embedded: {
      type: Boolean,
      required: false,
      default: false,
    },
  },

  computed: {
    mainContainerGridColumn() {
      if (this.embedded) return "grid__col-12 tabs__content--embedded";

      return "grid__col-9";
    },
  },
};
</script>
