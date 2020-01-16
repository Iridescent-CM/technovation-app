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
        <pitch :solo="true" />
      </div>

      <question-section
        title="Pitch (20 points)"
        prevSection="technical"
        section="pitch"
        :nextSection="nextSection"
      >
        <p slot="section-summary" class="help-text">
          To assess how well a team presented (or pitched) their idea to you, please
          refer to all submission elements and the
          <a href="https://technovationchallenge.org/wp-content/uploads/2019/10/Pitch.png">rubric</a>.
        </p>

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
import TeamInfo from '../TeamInfo'
import Screenshots from '../pieces/Screenshots'
import Pitch from '../pieces/Pitch'

import QuestionSection from '../QuestionSection'

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
    Pitch,
  },
}
</script>
