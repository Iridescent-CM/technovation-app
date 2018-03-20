<template>
  <question-section
    title="Technical (20 points)"
    referTo="source code, screenshots, and demo video."
    prevSection="ideation"
    section="technical"
    nextSection="pitch"
  >
    <li class="score-question">
      {{ teamName }} earned
      <strong>{{ checklistPoints }} points</strong>
      for their code checklist.
    </li>
  </question-section>
</template>

<script>
import QuestionSection from './QuestionSection'

export default {
  computed: {
    teamName () {
      return this.$store.getters.teamName
    },

    checklistPoints () {
      return this.$store.getters.checklistPoints
    },
  },

  components: {
    QuestionSection,
  },
}
</script>
