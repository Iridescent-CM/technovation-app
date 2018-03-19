<template>
  <question-section
    title="Ideation (15 points)"
    referTo="app name and description, pitch video, and demo video."
    nextSection="technical"
    :questions="questions"
  ></question-section>
</template>

<script>
import QuestionSection from './QuestionSection'

export default {
  computed: {
    questions () {
      return this.$store.getters.ideationQuestions
    },
  },

  components: {
    QuestionSection,
  },
}
</script>
