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
        <div class="mb-8" v-html="submission.learning_journey"></div>

        <p class="font-bold text-lg">Screenshots</p>
        <p class="border-l-2 border-energetic-blue bg-blue-50 p-2 mb-6 text-base">
          Click image to expand. Enlarged images may be pixelated. Please focus on the content of the images rather than the photo quality.
        </p>
        <Screenshots/>
      </template>
    </GenericJudgingContainer>
  </div>
</template>

<script>
import { mapState } from 'vuex'
import GenericJudgingContainer from "../../components/GenericJudgingContainer";
import Template from "../../../components/job_process/template";
import Screenshots from "../pieces/Screenshots";

export default {

  computed: mapState(['submission']),

  components: {
    GenericJudgingContainer,
    Template,
    Screenshots
  },
}
</script>
