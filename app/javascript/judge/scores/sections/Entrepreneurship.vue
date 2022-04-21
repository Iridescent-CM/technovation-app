<template>
  <div>
    <GenericJudgingContainer
        :heading="team.division === 'senior' ? 'Business Plan' : 'User Adoption Plan'"
        section="entrepreneurship"
        prev-section="demo"
        prev-button-text="Demo"
        next-section="overall"
        next-button-text="Review Score"
    >
      <template v-slot:main-content>
        <business />
      </template>
    </GenericJudgingContainer>
  </div>
</template>

<script>
import { mapState } from 'vuex'

import TeamInfo from '../TeamInfo'
import Pitch from '../pieces/Pitch'
import Business from '../pieces/Business'
import GenericJudgingContainer from "../../components/GenericJudgingContainer";

export default {
  computed: mapState([
      'submission',
      'team'
  ]),
  components: {
    TeamInfo,
    Pitch,
    Business,
    GenericJudgingContainer,
  },
}
</script>
