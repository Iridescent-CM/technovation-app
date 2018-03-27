<template>
  <div v-if="team.live_event" class="grid__col-6">
    <h4>Regional Pitch Events</h4>

    <p>
      <a :href="submission.pitch_presentation_url" target="_blank">
        Open the pitch presentation slides
      </a>
    </p>
  </div>
</template>

<script>
import { mapState } from 'vuex'

export default {
  computed: mapState(['team', 'submission']),
}
</script>
