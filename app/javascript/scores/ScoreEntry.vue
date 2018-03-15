<template>
  <ol>
    <li v-for="question in questions">
      {{ question.text }}

      <ol>
        <li
          v-for="n in question.worth"
          :class="[
            'score-value',
            question.score === n ? 'selected' : ''
          ]"
          @click="updateScores(question, n)"
          v-tooltip.top-center="explainScores(n)"
        >
          {{ n }}
        </li>
      </ol>
    </li>
  </ol>
</template>

<script>
export default {
  props: ['questions'],

  methods: {
    updateScores (question, score) {
      this.$store.commit('updateScores', {
        section: question.section,
        idx: question.idx,
        score: score,
      })
    },

    explainScores (n) {
      switch (n) {
        case 1:
          return "Incomplete. The work is missing."
        case 2:
          return "Needs Improvement. The work needs major improvement."
        case 3:
          return "Acceptable. The work needs minor improvement."
        case 4:
          return "Good. The work is of good quality."
        case 5:
          return "Excellent. The work is of excellent quality"
      }
    },
  }
}
</script>
