<template>
  <div >
    <template>
      <div>
        <GenericJudgingContainer
          heading="Pitch"
          section="pitch"
          next-section="demo"
          prev-section="ideation"
          prev-button-text="Learning Journey"
        >
          <template v-slot:main-content>
            <p class="font-bold text-lg">Videos</p>
            <PitchVideoLink />
          </template>
        </GenericJudgingContainer>
      </div>
    </template>
  </div>
</template>

<script>
import { mapState } from 'vuex'

import PitchVideoLink from '../pieces/PitchVideoLink'
import EnergeticContainer from "../../components/EnergeticContainer";
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
    EnergeticContainer,
    PitchVideoLink,
    GenericJudgingContainer
  },
}
</script>
