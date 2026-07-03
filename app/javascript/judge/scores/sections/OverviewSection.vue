<template>
  <div>
    <EnergeticContainer heading="Overview">
      <div v-if="!submission.id" class="loading">
        <app-icon name="spinner" class-name="spin" />
        <div>Loading the submission... Happy Judging!</div>
      </div>
      <div v-else>
        <SubmissionOverview />
      </div>
    </EnergeticContainer>
  </div>
</template>

<script>
import { mapState } from "vuex";
import AppIcon from "../../../components/AppIcon";

import EnergeticContainer from "../../../components/rebrand/EnergeticContainer";
import SubmissionOverview from "../SubmissionOverview";

export default {
  name: "OverviewSection",
  components: {
    AppIcon,
    EnergeticContainer,
    SubmissionOverview,
  },
  computed: {
    ...mapState(["team", "score", "submission"]),
  },
};
</script>
