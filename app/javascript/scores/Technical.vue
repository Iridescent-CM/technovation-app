<template>
  <question-section
    title="Technical (20 points)"
    referTo="source code, screenshots, and demo video."
    nextSection="pitch"
    prevSection="ideation"
    :questions="questions"
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

    questions () {
      return this.$store.getters.technicalQuestions
    },
  },

  components: {
    QuestionSection,
  },
}
</script>
