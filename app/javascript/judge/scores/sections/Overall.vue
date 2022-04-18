<template>
  <GenericJudgingContainer
      heading="Overall Impression"
      section="overall"
      next-section="review-score"
      prev-section="entrepreneurship"
  >
    <template v-slot:main-content>
      <h1 class="border--b-thin-primary">{{ submission.name }}</h1>

      <div class="app-description" v-html="submission.description"></div>
    </template>
  </GenericJudgingContainer>
</template>

<script>
import { mapState } from 'vuex';

import TeamInfo from '../TeamInfo';
import QuestionSection from '../QuestionSection';
import GenericJudgingContainer from "../../components/GenericJudgingContainer";

export default {
  components: {
    TeamInfo,
    QuestionSection,
    GenericJudgingContainer
  },

  computed: mapState(['submission']),
}
</script>
