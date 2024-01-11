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

    <div style="background-color: #f5f5f5; padding: 12px 8px; margin-bottom: 12px; font-size: 1rem;">
      <p>"Forming teams allowed" enables:</p>
      <ul style="margin-top: 0; font-size: 1rem;">
        <li>Creating teams</li>
        <li>Team invites</li>
        <li>Team join requests</li>
        <li>The checkbox for "Allow other students to find our team and request to join us"</li>
      </ul>
    </div>

    <p class="notice info hint">
      <icon name="exclamation-circle" :size="16" color="00529B" />
      Please note that when the "Forming teams allowed" box is checked, students can invite people to register and join their team even if registration is closed.
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
