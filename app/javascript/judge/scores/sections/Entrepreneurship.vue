<template>
  <div>
    <GenericJudgingContainer
        :heading="team.division === 'senior' ? 'Business Plan' : 'User Adoption Plan'"
        section="entrepreneurship"
        prev-section="demo"
        next-section="ideation"
    >
      <template v-slot:main-content>
        <business />
      </template>
    </GenericJudgingContainer>
  </div>
</template>

<script>
import { mapState } from 'vuex'

import Business from '../pieces/Business'
import GenericJudgingContainer from "../../components/GenericJudgingContainer";

export default {
  computed: mapState([
      'submission',
      'team'
  ]),
  components: {
    Business,
    GenericJudgingContainer,
  },
}
</script>
