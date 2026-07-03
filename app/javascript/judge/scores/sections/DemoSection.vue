<template>
  <div>
    <GenericJudgingContainer
      heading="Technical"
      section="demo"
      :next-section="nextSection"
      prev-section="pitch"
    >
      <template #main-content>
        <DemoVideoLink />
        <SourceCode />
      </template>
    </GenericJudgingContainer>
  </div>
</template>

<script>
import { mapState } from "vuex";

import GenericJudgingContainer from "../../components/GenericJudgingContainer";
import DemoVideoLink from "../pieces/DemoVideoLink";
import SourceCode from "../pieces/SourceCode";

export default {
  name: "DemoSection",
  components: {
    GenericJudgingContainer,
    DemoVideoLink,
    SourceCode,
  },

  computed: {
    ...mapState(["team", "submission"]),

    nextSection() {
      return this.team.division === "senior" || this.team.division === "junior"
        ? "entrepreneurship"
        : "ideation";
    },
  },
};
</script>
