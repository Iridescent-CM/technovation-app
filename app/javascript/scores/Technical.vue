<template>
  <question-section
    title="Technical (20 points)"
    referTo="source code, screenshots, and demo video."
    nextSection="pitch"
    prevSection="ideation"
    :questions="questions"
  ></question-section>
</template>

<script>
import QuestionSection from './QuestionSection'

export default {
  computed: {
    questions () {
      return this.$store.getters.technicalQuestions
    },
  },

  components: {
    QuestionSection,
  },
}
</script>
