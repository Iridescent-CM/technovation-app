<template>
  <div><slot name="scores" /></div>
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
  },
}
</script>

<style lang="scss" scoped>
</style>