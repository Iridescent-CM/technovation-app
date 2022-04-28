<template>
  <div>
    <GenericJudgingContainer
      heading="Demo"
      section="demo"
      :next-section="nextSection"
      prevSection="pitch"
    >
      <template v-slot:main-content>
        <DemoVideoLink/>
        <Code/>
      </template>
    </GenericJudgingContainer>
  </div>
</template>

<script>
import { mapState } from 'vuex'

import GenericJudgingContainer from "../../components/GenericJudgingContainer";
import DemoVideoLink from "../pieces/DemoVideoLink";
import Code from "../pieces/Code";

export default {
  computed: {
    ...mapState(['team', 'submission']),

    nextSection () {
      return (this.team.division === 'senior' || this.team.division === 'junior') ?
        'entrepreneurship' :
        'review-score'
    },
  },

  components: {
    GenericJudgingContainer,
    DemoVideoLink,
    Code
  },
}
</script>
