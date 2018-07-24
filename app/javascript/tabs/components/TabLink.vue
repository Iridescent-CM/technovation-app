<template>
  <router-link
    tag="li"
    class="tabs__menu-link"
    active-class="tabs__menu-link--active"
    :to="to"
  >
    <button role="button" class="tabs__menu-button">
      <slot></slot>
    </button>
  </router-link>
</template>

<script>
export default {
  props: {
    to: {
      type: Object,
      required: true,
    },
  },
}
</script>