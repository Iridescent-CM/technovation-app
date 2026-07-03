<template>
  <div>
    <template v-if="team.division === 'senior' || team.division === 'junior'">
      <a
        :href="submission.business_plan_url"
        target="_blank"
        class="text-energetic-blue text-3xl"
        @click="trackBusinessPlanDownload"
      >
        <AppIcon name="file-o" class="inline" color="0075cf" />
        Read the <span>{{ documentType }}</span>
      </a>
    </template>

    <template v-else>
      Beginner Division teams do not upload a business canvas.
    </template>
  </div>
</template>

<script>
import { mapState } from "vuex";
import AppIcon from "../../../components/AppIcon";

export default {
  name: "BusinessSection",
  components: {
    AppIcon,
  },
  computed: {
    ...mapState(["score", "submission", "team"]),

    documentType() {
      switch (this.team.division) {
        case "senior":
          return "business canvas";
        case "junior":
          return "user adoption plan";
        default:
          return "";
      }
    },
  },
  methods: {
    async trackBusinessPlanDownload() {
      await window.axios.patch(`/judge/scores/${this.score.id}`, {
        submission_score: { downloaded_business_plan: true },
      });
    },
  },
};
</script>
