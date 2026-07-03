<template>
  <div>
    <GenericJudgingContainer
      :heading="
        team.division === 'senior' ? 'Business Canvas' : 'User Adoption Plan'
      "
      section="entrepreneurship"
      prev-section="demo"
      next-section="ideation"
    >
      <template #main-content>
        <BusinessSection />
      </template>
    </GenericJudgingContainer>
  </div>
</template>

<script>
import { mapState } from "vuex";

import BusinessSection from "../pieces/BusinessSection";
import GenericJudgingContainer from "../../components/GenericJudgingContainer";

export default {
  name: "EntrepreneurshipSection",
  components: {
    BusinessSection,
    GenericJudgingContainer,
  },
  computed: mapState(["submission", "team"]),
};
</script>
