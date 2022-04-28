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
            <PitchVideoLink />
          </template>
        </GenericJudgingContainer>
      </div>
    </template>
  </div>
</template>

<script>
import { mapState } from 'vuex'

import GenericJudgingContainer from "../../components/GenericJudgingContainer";
import PitchVideoLink from '../pieces/PitchVideoLink'

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
    GenericJudgingContainer,
    PitchVideoLink
  },
}
</script>
