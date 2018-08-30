
<template>
  <ul class="tabs__menu">
    <tab-link :to="{ name: 'events' }">
      Regional Live Events
    </tab-link>
  </ul>
</template>

<script>
import TabLink from 'tabs/components/TabLink'

export default {
  components: {
    TabLink,
  },

  computed: {
    regionalEventCondition () {
      return false
    },
  },
}
</script>