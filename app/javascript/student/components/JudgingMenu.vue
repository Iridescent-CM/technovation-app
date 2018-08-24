
<template>
  <ul class="tabs__menu">
    <tab-link :to="{ name: 'events' }">
      <icon
        :name="completedEnabledOrDisabledIcon(regionalEventCondition)"
        size="16"
        :color="$route.name === 'events' ? '000000' : '28A880'"
      />
      Regional Live Events
    </tab-link>
  </ul>
</template>

<script>
import Icon from 'components/Icon'
import TabLink from 'tabs/components/TabLink'

export default {
  components: {
    Icon,
    TabLink,
  },

  computed: {
    regionalEventCondition () {
      return false
    },
  },

  methods: {
    completedEnabledOrDisabledIcon (conditionToComplete) {
      if (conditionToComplete)
        return 'check-circle'

      return 'circle-o'
    },
  },
}
</script>