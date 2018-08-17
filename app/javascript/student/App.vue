<template>
  <div class="tabs tabs--css-only col--sticky-parent">
    <div class="col--sticky-spacer">
      <ul class="tabs__menu col--sticky">
        <tab-link :to="{ name: 'basic-profile' }">1. Registration</tab-link>
        <tab-link :to="{ name: 'parental-consent' }">2. Build your team</tab-link>
        <tab-link :to="{ name: 'submission' }">3. Submit your project</tab-link>
        <tab-link :to="{ name: 'judging' }">4. Compete in the judging rounds</tab-link>
        <tab-link :to="{ name: 'scores' }">5. Get scores & valuable feedback</tab-link>
      </ul>
    </div>

    <div class="tabs__content">
      <router-view :key="$route.name">
        <div slot="parental-consent"><slot name="parental-consent" /></div>
        <div slot="find-team"><slot name="find-team" /></div>
        <div slot="create-team"><slot name="create-team" /></div>
      </router-view>
    </div>
  </div>
</template>

<script>
import { createNamespacedHelpers } from 'vuex'

import Icon from 'components/Icon'
import TabLink from 'tabs/components/TabLink'

const { mapState, mapGetters } = createNamespacedHelpers('student')

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
    if (jQuery) {
      $(".col--sticky").stick_in_parent({
        parent: ".col--sticky-parent",
        spacer: ".col--sticky-spacer",
        recalc_every: 1,
      })
    }
  },
}
</script>

<style lang="scss" scoped>
</style>