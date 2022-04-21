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
            <Pitch/>
          </template>
        </GenericJudgingContainer>
      </div>
    </template>
  </div>
</template>

<script>
import { mapState } from 'vuex'

import Pitch from '../pieces/Pitch'
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
    Pitch,
    GenericJudgingContainer
  },
}
</script>
