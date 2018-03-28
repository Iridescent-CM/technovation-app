<template>
  <div class="grid">
    <div class="grid__col-12 grid__col--bleed-y">
      <h2>Technical</h2>
    </div>

    <team-info />

    <div class="grid__col-9 grid__col--bleed-y">
      <h1>{{ submission.name }}</h1>

      <div class="app-description" v-html="submission.description"></div>

      <screenshots />

      <div class="grid grid--bleed submission-pieces mulberry-row">
        <submission-pitch :solo="true" />
      </div>

      <question-section
        title="Pitch (20 points)"
        referTo="demo video and pitch video."
        prevSection="technical"
        section="pitch"
        :nextSection="nextSection"
      >
        <p slot="comment-tips">
          English may not be the native language for the students.
          Focus on how well the team did at telling the story of their
          submission and convincing you of their solution.
        </p>
      </question-section>
    </div>
  </div>
</template>

<script>
import TeamInfo from './TeamInfo'
import Screenshots from './Screenshots'
import SubmissionPitch from './SubmissionPitch'

import QuestionSection from './QuestionSection'

import { mapState } from 'vuex'

export default {
  computed: {
    ...mapState(['team', 'submission']),

    nextSection () {
      return this.team.division === 'senior' ?
        'entrepreneurship' :
        'overall'
    },
  },

  components: {
    QuestionSection,
    TeamInfo,
    Screenshots,
    SubmissionPitch,
  },
}
</script>
