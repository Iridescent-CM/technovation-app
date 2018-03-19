<template>
  <question-section
    title="Overall Impression (25 points)"
    referTo="entire submission."
    nextSection="reviewScore"
    prevSection="entrepreneurship"
    :questions="questions"
  ></question-section>
</template>

<script>
import QuestionSection from './QuestionSection'

export default {
  computed: {
    questions () {
      return this.$store.getters.overallQuestions
    },
  },

  components: {
    QuestionSection,
  },
}
</script>
