<template>
  <question-section
    title="Overall Impression (25 points)"
    referTo="entire submission."
    prevSection="entrepreneurship"
    section="overall"
    nextSection="review-score"
    nextSectionTitle="Review score"
  ></question-section>
</template>

<script>
import QuestionSection from './QuestionSection'

export default {
  components: {
    QuestionSection,
  },
}
</script>
