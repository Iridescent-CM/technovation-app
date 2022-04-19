<template>
  <div>
    <GenericJudgingContainer
        heading="Demo"
        section="demo"
        next-section="business-plan"
    >
      <template v-slot:main-content>
        <p class="font-bold text-lg">Videos</p>
        <div class="grid grid--bleed submission-pieces primary-row">
          <pitch :solo="true" />
        </div>
      </template>
    </GenericJudgingContainer>
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
import GenericJudgingContainer from "../../components/GenericJudgingContainer";

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
    GenericJudgingContainer
  },
}
</script>
