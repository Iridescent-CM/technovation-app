<template>
  <question-section
    title="Pitch (20 points)"
    referTo="demo video and pitch video."
    prevSection="technical"
    section="pitch"
    nextSection="entrepreneurship"
  >
    <p slot="comment-tips">
      English may not be the native language for the students.
      Focus on how well the team did at telling the story of their
      submission and convincing you of their solution.
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
