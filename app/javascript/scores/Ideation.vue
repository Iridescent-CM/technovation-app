<template>
  <div>
    <h1>Ideation (15 points)</h1>

    <p>
      Refer to the app name and description, pitch video, and demo video.
    </p>

    <score-entry :questions="questions"></score-entry>

    <button
      class="button button--small"
      @click="$store.commit('changeSection', 'technical')">
      Next: Technical
    </button>
  </div>
</template>

<script>
import ScoreEntry from './ScoreEntry'

export default {
  computed: {
    questions () {
      return this.$store.getters.ideationQuestions
    },
  },

  components: {
    ScoreEntry,
  },
}
</script>
