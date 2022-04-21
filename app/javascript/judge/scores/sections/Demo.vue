<template>
  <div>
    <GenericJudgingContainer
      heading="Demo"
      section="demo"
      :next-section="nextSection"
      :next-button-text="nextButtonText"
      prevSection="pitch"
    >
      <template v-slot:main-content>
        <p class="font-bold text-lg">Videos</p>
        <Demo/>
      </template>
    </GenericJudgingContainer>
  </div>
</template>

<script>
import { mapState } from 'vuex'

import EnergeticContainer from "../../components/EnergeticContainer";
import ThickRule from "../../components/ThickRule";
import GenericJudgingContainer from "../../components/GenericJudgingContainer";
import Demo from "../pieces/Demo";

export default {
  computed: {
    ...mapState(['team', 'submission']),

    nextSection () {
      return (this.team.division === 'senior' || this.team.division === 'junior') ?
        'entrepreneurship' :
        'overall'
    },

    nextButtonText () {
      switch (this.team.division) {
        case 'senior':
          return 'Business Plan'
          break
        case 'junior':
          return 'User Adoption Plan'
          break
      }
    }
  },

  components: {
    ThickRule,
    EnergeticContainer,
    GenericJudgingContainer,
    Demo
  },
}
</script>
