<template>
  <div>
    <GenericJudgingContainer
      heading="Learning Journey"
      section="ideation"
      next-section="pitch"
      prev-section="overview"
      prev-button-text="Project Name & Description"
    >
      <template v-slot:main-content>
        <p class="font-bold text-lg">{{ submission.name }}</p>
        <div v-html="submission.description"></div>
      </template>
    </GenericJudgingContainer>
  </div>
</template>

<script>
import TeamInfo from '../TeamInfo'
import QuestionSection from '../QuestionSection'
import EnergeticContainer from "../../components/EnergeticContainer";
import ThickRule from "../../components/ThickRule";

import { mapState } from 'vuex'
import GenericJudgingContainer from "../../components/GenericJudgingContainer";
import Template from "../../../components/job_process/template";

export default {
  computed: mapState(['submission']),

  components: {
    Template,
    QuestionSection,
    TeamInfo,
    EnergeticContainer,
    ThickRule,
    GenericJudgingContainer
  },
}
</script>
