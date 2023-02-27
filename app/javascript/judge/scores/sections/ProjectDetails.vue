<template>
    <div>
      <GenericJudgingContainer
          heading="Project Description"
          section="project_details"
          prev-section="overview"
          prev-button-text="Overview"
          next-section="pitch"
          next-button-text="Learning Journey"
      >
        <template v-slot:main-content>
          <p class="font-bold text-lg">{{ submission.name }}</p>
          <div style="white-space: pre-line;">{{ submission.description }}</div>
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
