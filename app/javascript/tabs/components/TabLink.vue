<template>
  <router-link
    tag="li"
    class="tabs__menu-link"
    active-class="tabs__menu-link--active"
    :to="to"
  >
    <button
      role="button"
      :class="buttonClasses"
      v-tooltip="{
        content: disabledTooltip,
        classes: ['tabs__menu-button--tooltip'],
      }"
    >
      <slot></slot>
    </button>
    <slot name="subnav" />
  </router-link>
</template>

<script>
import { VTooltip } from 'v-tooltip'

import 'components/tooltip.scss'

export default {
  directives: {
    tooltip: VTooltip,
  },

  props: {
    disabledTooltip: {
      type: String,
      default: '',
    },

    to: {
      type: Object,
      required: true,
    },
  },

  computed: {
    buttonClasses () {
      return {
        'tabs__menu-button': true,
        disabled: this.disabledTooltip !== '',
      }
    },
  },
}
</script>