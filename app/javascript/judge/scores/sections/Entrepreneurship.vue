<template>
  <question-section
    title="Entrepreneurship (20 points)"
    referTo="business plan, demo video, and pitch video."
    prevSection="pitch"
    section="entrepreneurship"
    nextSection="overall"
  >
    <p slot="comment-tips">
      How well the team did in developing a business.
      Like the technical section, entrepreneurship is not
      about how complex the business plan is, but how
      well the business meets the needs outlined by the team.
    </p>
  </question-section>
</template>

<script>
import QuestionSection from '../QuestionSection'

export default {
  components: {
    QuestionSection,
  },
}
</script>
