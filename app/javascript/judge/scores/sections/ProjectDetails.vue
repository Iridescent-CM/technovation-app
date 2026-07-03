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
      <template #main-content>
        <div class="mb-6">
          <p class="font-bold text-lg">Project Name</p>
          <p class="text-lg">{{ submission.name }}</p>
        </div>
        <div class="mb-6">
          <p class="font-bold text-lg">Project Description</p>
          <div style="white-space: pre-line">{{ submission.description }}</div>
        </div>
        <div>
          <p class="font-bold text-lg">Ethics Description</p>
          <div>{{ submission.ethics_description }}</div>
        </div>
      </template>
    </GenericJudgingContainer>
  </div>
</template>

<script>
import { mapState } from "vuex";

import GenericJudgingContainer from "../../components/GenericJudgingContainer";

export default {
  components: {
    GenericJudgingContainer,
  },

  computed: mapState(["submission"]),
};
</script>
