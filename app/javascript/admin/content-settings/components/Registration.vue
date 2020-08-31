<template>
  <div id="registration">
    <h4>User Registations</h4>
    <div v-for="(label, scope) in checkboxes" :key="scope">
      <p class="inline-checkbox">
        <input
          v-if="judgingEnabled"
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
        >
        <label
          :for="`season_toggles_${scope}_signup`"
          :class="{ 'label--disabled': judgingEnabled }"
        >{{ label }}</label>
      </p>
      <div v-if="judgingEnabled" class="notice info hint user-notice">
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
      },
    }
  },

  computed: {
    ...mapGetters([
      'judgingEnabled',
    ])
  },
}
</script>

<style scoped>
</style>
