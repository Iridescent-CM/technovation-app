<template>
  <div class="grid">
    <div class="grid__col-12 grid__col--bleed-y">
      <h2>Technical</h2>
    </div>

    <team-info />

    <div class="grid__col-9 grid__col--bleed-y">
      <h1 class="border--b-thin-primary">{{ submission.name }}</h1>

      <div class="app-description" v-html="submission.description"></div>

      <screenshots />

      <div class="grid grid--bleed submission-pieces primary-row">
        <pitch />
        <tc-code />
      </div>

      <question-section
        title="Technical (20 points)"
        referTo="source code, screenshots, and demo video."
        prevSection="ideation"
        section="technical"
        nextSection="pitch"
      >
        <li class="score-question">
          {{ team.name }} automatically earned
          {{ submission.total_checklist_points }}
          {{ submission.total_checklist_points | pluralize('point') }}
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
import TeamInfo from '../TeamInfo'

import Screenshots from '../pieces/Screenshots'
import Pitch from '../pieces/Pitch'
import TcCode from '../pieces/Code'

import QuestionSection from '../QuestionSection'

import { mapState } from 'vuex'

export default {
  computed: mapState(['team', 'submission']),

  components: {
    QuestionSection,
    TeamInfo,
    Screenshots,
    Pitch,
    TcCode,
  },
}
</script>
