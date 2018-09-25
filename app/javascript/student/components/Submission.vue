<template>
  <div id="your-submission" class="tabs tabs--vertical tabs--css-only grid">
    <div class="tabs__content grid__col-12 tabs__content--embedded">
      <div class="grid">
        <div class="grid__col-8">
          <slot name="submission" />
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import StickySidebar from 'directives/sticky-sidebar'

export default {
  name: 'submission',

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