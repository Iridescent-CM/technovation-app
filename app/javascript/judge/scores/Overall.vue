<template>
  <question-section
    title="Overall Impression (25 points)"
    referTo="entire submission."
    prevSection="entrepreneurship"
    section="overall"
    nextSection="review-score"
    nextSectionTitle="Review score"
    :solo="true"
  >
    <p slot="comment-tips">
      Considering the native language and ages of the team,
      how does this submission stand out for you? How well
      do all the parts work together?
    </p>
  </question-section>
</template>

<script>
import QuestionSection from './QuestionSection'

export default {
  components: {
    QuestionSection,
  },
}
</script>
