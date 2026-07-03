<template>
  <div>
    <GenericJudgingContainer
      heading="Learning Journey"
      section="ideation"
      :prev-section="prevSection"
      next-section="review-score"
      next-button-text="Review Score"
    >
      <template #main-content>
        <p class="font-bold text-lg">Project Name</p>
        <p class="mb-6">{{ submission.name }}</p>

        <p class="font-bold text-lg mb-0">Learning Journey</p>
        <p
          class="mb-6"
          style="white-space: pre-line"
          v-text="submission.learning_journey"
        ></p>

        <div
          v-if="team.division === 'senior' || team.division === 'junior'"
          class="mb-6"
        >
          <p class="font-bold text-lg">Information Legitimacy Description</p>
          <p
            class="mb-6"
            style="white-space: pre-line"
            v-text="submission.information_legitimacy_description"
          ></p>

          <p class="font-bold text-lg">Bibliography</p>
          <a
            :href="submission.bibliography_url"
            target="_blank"
            class="text-energetic-blue"
          >
            <AppIcon name="file-o" class="inline text-sm" color="0075cf" />
            View the bibliography
          </a>
        </div>

        <p class="font-bold text-lg">Screenshots</p>
        <p
          class="border-l-2 border-energetic-blue bg-blue-50 p-2 mb-6 text-base"
        >
          Click image to expand. Enlarged images may be pixelated. Please focus
          on the content of the images rather than the photo quality.
        </p>
        <SubmissionScreenshots />
      </template>
    </GenericJudgingContainer>
  </div>
</template>

<script>
import { mapState } from "vuex";
import GenericJudgingContainer from "../../components/GenericJudgingContainer";
import SubmissionScreenshots from "../pieces/SubmissionScreenshots";
import AppIcon from "../../../components/AppIcon.vue";

export default {
  name: "IdeationSection",
  components: {
    AppIcon,
    GenericJudgingContainer,
    SubmissionScreenshots,
  },

  computed: {
    ...mapState(["team", "submission"]),
    prevSection() {
      return this.team.division === "senior" || this.team.division === "junior"
        ? "entrepreneurship"
        : "demo";
    },
  },
};
</script>
