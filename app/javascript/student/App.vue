<template>
  <div class="tabs tabs--css-only">
    <ul class="tabs__menu">
      <tab-link :to="{ name: 'basic-profile' }">1. Registration</tab-link>
      <tab-link :to="{ name: 'team' }">2. Build your team</tab-link>
      <tab-link :to="{ name: 'submission' }">3. Submit your project</tab-link>
      <tab-link :to="{ name: 'judging' }">4. Compete in the judging rounds</tab-link>
      <tab-link :to="{ name: 'scores' }">5. Get scores & valuable feedback</tab-link>
    </ul>

    <div class="tabs__content">
      <router-view></router-view>
    </div>
  </div>
</template>

<script>
import { mapState, mapGetters } from 'vuex'

import Icon from 'components/Icon'
import TabLink from 'tabs/components/TabLink'

export default {
  name: 'app',

  components: {
    Icon,
    TabLink,
  },

  computed: {
    ...mapState([
    ]),

    ...mapGetters([
    ]),
  },

  mounted () {
    if (jQuery)
      $(".col--sticky").stick_in_parent({
        parent: ".col--sticky-parent",
        spacer: ".col--sticky-spacer",
        recalc_every: 1,
      })

    this.$store.commit('refs', this.$refs)
  },

  methods: {
  },
}
</script>

<style lang="scss" scoped>
</style>