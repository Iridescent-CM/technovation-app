<template>
  <div>
    <h1>Technical (20 points)</h1>

    <p>
      Refer to the source code, screenshots, and demo video.
    </p>

    <score-entry :questions="questions"></score-entry>

    <button
      class="button button--small"
      @click="$store.commit('changeSection', 'ideation')">
      Back: Ideation
    </button>
  </div>
</template>

<script>
import ScoreEntry from './ScoreEntry'

export default {
  computed: {
    questions () {
      return this.$store.getters.technicalQuestions
    },
  },

  components: {
    ScoreEntry,
  },
}
</script>
