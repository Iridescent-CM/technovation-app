<template>
  <div class="grid">
    <div class="grid__col-12 grid__col--bleed-y">
      <h2>Technical</h2>
    </div>

    <team-info />

    <div class="grid__col-9 grid__col--bleed-y">
      <h1>{{ submission.name }}</h1>

      <screenshots />

      <div class="grid grid--bleed submission-pieces">
        <submission-pitch />
        <submission-code />
      </div>

      <submission-code-checklist />

      <question-section
        title="Technical (20 points)"
        referTo="source code, screenshots, and demo video."
        prevSection="ideation"
        section="technical"
        nextSection="pitch"
      >
        <li class="score-question">
          {{ team.name }} earned
          <strong>{{ submission.total_checklist_points }} points</strong>
          for their code checklist.
        </li>

        <p slot="comment-tips">
          This section is not about how complex the app is,
          but how well the app solves the problem and meets
          the needs outlined by the team.
        </p>
      </question-section>
    </div>
  </div>
</template>

<script>
import TeamInfo from './TeamInfo'
import Screenshots from './Screenshots'
import SubmissionPitch from './SubmissionPitch'
import SubmissionCode from './SubmissionCode'
import SubmissionCodeChecklist from './SubmissionCodeChecklist'

import QuestionSection from './QuestionSection'

import { mapState } from 'vuex'

export default {
  computed: mapState(['team', 'submission']),

  components: {
    QuestionSection,
    TeamInfo,
    Screenshots,
    SubmissionPitch,
    SubmissionCode,
    SubmissionCodeChecklist,
  },
}
</script>
