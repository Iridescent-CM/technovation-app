<template>
  <question-section
    title="Ideation (15 points)"
    referTo="app name and description, pitch video, and demo video."
    section="ideation"
    nextSection="technical"
  >
    <p slot="comment-tips">
      Be sensitive to cultural differences and
      focus on how well the team identified the problem
      and presented a solution.
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
