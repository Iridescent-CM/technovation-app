<template>
  <div id="scores-and-certificates">
    <h4>Scores &amp; Certificates</h4>

    <p class="inline-checkbox">
      <input
        v-if="judgingEnabled"
        id="season_toggles_display_scores"
        type="checkbox"
        :value="0"
        :disabled="true"
      >
      <input
        v-else
        id="season_toggles_display_scores"
        type="checkbox"
        v-model="$store.state.display_scores"
        :disabled="!isSuperAdmin"
      >
      <label
        for="season_toggles_display_scores"
        :class="{ 'label--disabled': judgingEnabled }"
      >Scores &amp; Certificates Accessible</label>
    </p>

    <div v-if="judgingEnabled" class="notice info hint user-notice">
      <icon name="exclamation-circle" :size="16" color="00529B" />
      When judging is enabled, scores &amp; certificates cannot be displayed
    </div>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'

import Icon from 'components/Icon.vue'

export default {
  name: 'scores-and-certificates-section',

  components: {
    Icon,
  },

  computed: {
    ...mapGetters([
      'judgingEnabled',
      'isSuperAdmin'
    ])
  }
}
</script>

<style scoped>
</style>