<template>
  <div>
    <GenericJudgingContainer
      heading="Learning Journey"
      section="ideation"
      next-section="pitch"
      prev-section="project_details"
      prev-button-text="Project Name & Description"
    >
      <template v-slot:main-content>
        <p class="font-bold text-lg">{{ submission.name }}</p>
        <div v-html="submission.learning_journey"></div>
      </template>
    </GenericJudgingContainer>
  </div>
</template>

<script>
import { mapState } from 'vuex'
import GenericJudgingContainer from "../../components/GenericJudgingContainer";
import Template from "../../../components/job_process/template";

export default {
  computed: mapState(['submission']),

  components: {
    GenericJudgingContainer,
    Template
  },
}
</script>
