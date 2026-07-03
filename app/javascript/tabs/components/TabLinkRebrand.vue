<template>
  <router-link
    :id="id"
    tag="li"
    active-class="tabs__menu-link--active"
    :to="to"
  >
    <div class="w-full text-left">
      <button v-tooltip="tooltipContent" class="flex">
        <app-icon
          :name="completedEnabledOrDisabledIcon"
          size="16"
          :color="activeEnabledOrDisabledColor"
          class="mt-1.5"
        />
        <slot></slot>
      </button>
      <slot name="subnav" />
    </div>
  </router-link>
</template>

<script>
import AppIcon from "components/AppIcon";

import { VTooltip } from "v-tooltip";

import "components/tooltip.scss";

export default {
  name: "TabLink",

  directives: {
    tooltip: VTooltip,
  },

  components: {
    AppIcon,
  },

  props: {
    id: {
      required: false,
      type: String,
      default: "",
    },

    disabledTooltip: {
      type: String,
      default: "",
    },

    to: {
      type: Object,
      required: true,
    },

    conditionToComplete: {
      type: Boolean,
      required: false,
      default: false,
    },

    conditionToEnable: {
      type: Boolean,
      required: false,
      default: false,
    },

    cssClasses: {
      type: [Array, String],
      required: false,
      default() {
        return [];
      },
    },
  },

  computed: {
    tooltipContent() {
      if (!this.conditionToEnable && this.disabledTooltip.length) {
        return {
          content: this.disabledTooltipMessage,
          classes: ["tabs__menu-button--tooltip"],
        };
      } else {
        return false;
      }
    },

    buttonClasses() {
      return {
        // 'tabs__menu-button': true,
        disabled: !this.conditionToEnable,
      };
    },

    completedEnabledOrDisabledIcon() {
      if (this.conditionToComplete) return "check-circle";

      return "circle-o";
    },

    activeEnabledOrDisabledColor() {
      if (
        (this.to.meta && this.to.meta.active) ||
        this.$route.name === this.to.name
      )
        return "000000";

      if (this.conditionToEnable) return "28A880";

      return "999999";
    },
  },

  methods: {
    disabledTooltipMessage() {
      if (!this.conditionToEnable) return this.disabledTooltip;

      return "";
    },
  },
};
</script>
