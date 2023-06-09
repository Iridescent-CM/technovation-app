<template>
  <div id="registration">
    <h4>User Registations</h4>
    <div v-for="(label, scope) in checkboxes" :key="scope">
      <p class="inline-checkbox">
        <input
          v-if="isRegistrationClosed(scope)"
          :id="`season_toggles_${scope}_signup`"
          type="checkbox"
          :value="0"
          :disabled="true"
        >
        <input
          v-else
          :id="`season_toggles_${scope}_signup`"
          type="checkbox"
          v-model="$store.state[`${scope}_signup`]"
          :disabled="!isSuperAdmin"
        >
        <label
          :for="`season_toggles_${scope}_signup`"
          :class="{ 'label--disabled': isRegistrationClosed(scope) }"
        >{{ label }}</label>
      </p>
      <div v-if="isRegistrationClosed(scope)" class="notice info hint user-notice">
        <icon name="exclamation-circle" :size="16" color="00529B" />
        When judging is enabled, {{ `${scope}s` }} cannot sign up
      </div>
    </div>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'

import Icon from 'components/Icon.vue'

export default {
  name: 'registration-section',

  components: {
    Icon,
  },

  data () {
    return {
      checkboxes: {
        student: 'Students',
        mentor: 'Mentors',
        judge: 'Judges',
      },
    }
  },

  computed: {
    ...mapGetters([
      'judgingEnabled',
      'isSuperAdmin'
    ])
  },

  methods: {
    isRegistrationClosed(scope) {
      return (scope == 'student' || scope == 'mentor') && this.judgingEnabled
    }
  }
}
</script>

<style scoped>
</style>
