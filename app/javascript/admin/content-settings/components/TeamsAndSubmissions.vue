<template>
  <div id="teams-and-submissions">
    <h4>Teams &amp; Submissions</h4>

    <p class="inline-checkbox">
      <input
        v-if="judgingEnabled"
        id="season_toggles_team_building_enabled"
        type="checkbox"
        :value="0"
        :disabled="true"
      >
      <input
        v-else
        id="season_toggles_team_building_enabled"
        type="checkbox"
        v-model="$store.state.team_building_enabled"
        :disabled="!isSuperAdmin"
      >
      <label
        for="season_toggles_team_building_enabled"
        :class="{ 'label--disabled': judgingEnabled }"
      >Forming teams allowed</label>
    </p>

    <div v-if="judgingEnabled" class="notice info hint user-notice">
      <icon name="exclamation-circle" :size="16" color="00529B" />
      When judging is enabled, teams cannot be formed
    </div>

    <p class="inline-checkbox">
      <input
        v-if="judgingEnabled"
        id="season_toggles_team_submissions_editable"
        type="checkbox"
        :value="0"
        :disabled="true"
      >
      <input
        v-else
        id="season_toggles_team_submissions_editable"
        type="checkbox"
        v-model="$store.state.team_submissions_editable"
        :disabled="!isSuperAdmin"
      >
      <label
        for="season_toggles_team_submissions_editable"
        :class="{ 'label--disabled': judgingEnabled }"
      >Team submissions are editable</label>
    </p>

    <div v-if="judgingEnabled" class="notice info hint user-notice">
      <icon name="exclamation-circle" :size="16" color="00529B" />
      When judging is enabled, submissions cannot be edited
    </div>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'

import Icon from 'components/Icon.vue'

export default {
  name: 'teams-and-submissions-section',

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