<template>
  <div >
    <EnergeticContainer>
      <team-info />

      <div>
        <p class="font-bold text-lg">Videos</p>

        <div class="grid grid--bleed submission-pieces primary-row">
          <pitch :solo="true" />
        </div>

        <ThickRule/>

        <question-section
          prevSection="technical"
          section="pitch"
          :nextSection="nextSection"
        >
          <p slot="section-summary" class="help-text">
            To assess how well a team presented (or pitched) their idea to you, please
            refer to all submission elements and the
            <a target="_blank" href="http://technovation.staging.wpengine.com/wp-content/uploads/2021/03/Pitch.png">rubric</a>.
          </p>

          <p slot="comment-tips">
            English may not be the native language for the students.
            Focus on how well the team did at telling the story of their
            submission and convincing you of their solution.
          </p>
        </question-section>
      </div>
    </EnergeticContainer>
  </div>
</template>

<script>
import TeamInfo from '../TeamInfo'
import Screenshots from '../pieces/Screenshots'
import Pitch from '../pieces/Pitch'

import QuestionSection from '../QuestionSection'

import { mapState } from 'vuex'
import EnergeticContainer from "../../components/EnergeticContainer";
import ThickRule from "../../components/ThickRule";

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
    ThickRule,
    EnergeticContainer,
    QuestionSection,
    TeamInfo,
    Screenshots,
    Pitch,
  },
}
</script>
