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
        prevSection="ideation"
        section="technical"
        nextSection="pitch"
      >
        <p slot="section-summary" class="help-text">
          To determine the quality of the team's solution (app), please refer to
          all submission elements, test the source code and see the
          <a target="_blank" href="http://technovation.staging.wpengine.com/wp-content/uploads/2021/03/Technical.png">rubric</a>.
        </p>

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
  computed: mapState(['submission']),

  components: {
    QuestionSection,
    TeamInfo,
    Screenshots,
    Pitch,
    TcCode,
  },
}
</script>
