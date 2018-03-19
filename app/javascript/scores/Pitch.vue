<template>
  <question-section
    title="Pitch (20 points)"
    referTo="demo video and pitch video."
    nextSection="entrepreneurship"
    prevSection="technical"
    :questions="questions"
  ></question-section>
</template>

<script>
import QuestionSection from './QuestionSection'

export default {
  computed: {
    questions () {
      return this.$store.getters.pitchQuestions
    },
  },

  components: {
    QuestionSection,
  },
}
</script>
