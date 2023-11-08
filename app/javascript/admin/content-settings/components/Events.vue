<template>
  <div id="events">
    <h4>Regional Pitch Events</h4>

    <p class="inline-checkbox">
      <input
        v-if="judgingEnabled"
        id="season_toggles_create_regional_pitch_event"
        type="checkbox"
        :value="0"
        :disabled="true"
      >
      <input
        v-else
        id="season_toggles_create_regional_pitch_event"
        type="checkbox"
        v-model="$store.state.create_regional_pitch_event"
        :disabled="!isSuperAdmin"
      >
      <label
        for="season_toggles_create_regional_pitch_event"
        :class="{ 'label--disabled': judgingEnabled }"
      >Creating regional pitch events allowed</label>
    </p>

    <div v-if="judgingEnabled" class="notice info hint user-notice">
      <icon name="exclamation-circle" :size="16" color="00529B" />
      When judging is enabled, regional pitch events cannot be created
    </div>

    <p class="inline-checkbox">
      <input
        v-if="judgingEnabled"
        id="season_toggles_select_regional_pitch_event"
        type="checkbox"
        :value="0"
        :disabled="true"
      >
      <input
        v-else
        id="season_toggles_select_regional_pitch_event"
        type="checkbox"
        v-model="$store.state.select_regional_pitch_event"
        :disabled="!isSuperAdmin"
      >
      <label
        for="season_toggles_select_regional_pitch_event"
        :class="{ 'label--disabled': judgingEnabled }"
      >Selecting regional pitch events allowed</label>
    </p>

    <div v-if="judgingEnabled" class="notice info hint user-notice">
      <icon name="exclamation-circle" :size="16" color="00529B" />
      When judging is enabled, regional pitch events cannot be selected
    </div>

    <p class="inline-checkbox">
      <input
        id="season_toggles_add_teams_to_regional_pitch_event"
        type="checkbox"
        v-model="$store.state.add_teams_to_regional_pitch_event"
        :disabled="!isSuperAdmin"
      >
      <label
        for="season_toggles_add_teams_to_regional_pitch_event"
      >Adding teams to regional pitch events allowed</label>
    </p>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'

import Icon from 'components/Icon.vue'

export default {
  name: 'events-section',

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
