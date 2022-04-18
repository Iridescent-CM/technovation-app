<template>
    <div>
      <GenericJudgingContainer
          heading="Project Name & Description"
          section="ideation"
          next-section="technical"
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
import Pitch from '../pieces/Pitch'
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
    Pitch,
    EnergeticContainer,
    ThickRule,
    GenericJudgingContainer
  },
}
</script>
