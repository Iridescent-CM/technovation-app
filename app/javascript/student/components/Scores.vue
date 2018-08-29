<template>
  <div class="tabs tabs--vertical tabs--css-only grid">
    <div class="tabs__content grid__col-12 tabs__content--embedded">
      <div class="grid">
        <div class="grid__col-8">
          <slot name="scores" />
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { mapGetters, mapActions, mapState } from 'vuex'

import Icon from 'components/Icon'
import TabLink from 'tabs/components/TabLink'
import StickySidebar from 'directives/sticky-sidebar'

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
    Icon,
    TabLink,
  },

  props: {
    stickySidebarClasses: {
      type: Array,
      default () {
        return []
      },
    },
  },

  computed: {
    ...mapState([]),

    ...mapGetters([]),
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