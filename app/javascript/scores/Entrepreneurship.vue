<template>
  <question-section
    title="Entrepreneurship (20 points)"
    referTo="business plan, demo video, and pitch video."
    nextSection="overall"
    prevSection="pitch"
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
