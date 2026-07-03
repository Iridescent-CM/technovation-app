<template>
  <div>
    <EnergeticContainer :heading="heading">
      <TeamInfo />
      <div>
        <slot name="main-content"></slot>

        <ThickRule />

        <question-section
          :prev-section="prevSection"
          :section="section"
          :next-section="nextSection"
        >
          <p slot="section-summary" class="help-text text-base">
            To determine if the team has built a solution that will positively
            impact them and their community, refer to all submission materials
            and the
            <a target="_blank" :href="rubricLink" class="tw-link-magenta"
              >rubric</a
            >.
          </p>

          <p slot="comment-tips" class="text-base">
            Be sensitive to cultural differences and focus on how well the team
            identified the problem and presented a solution.
          </p>
        </question-section>
      </div>
    </EnergeticContainer>
  </div>
</template>

<script>
import TeamInfo from "../scores/TeamInfo";
import QuestionSection from "../scores/QuestionSection";
import EnergeticContainer from "../../components/rebrand/EnergeticContainer";
import ThickRule from "../../components/rebrand/ThickRule";
import { mapState } from "vuex";
import { getJudgingRubricLink } from "../../utilities/judge-helpers";

export default {
  name: "GenericJudgingContainer",
  components: {
    TeamInfo,
    QuestionSection,
    EnergeticContainer,
    ThickRule,
  },
  props: {
    heading: {
      type: String,
      required: true,
    },

    section: {
      type: String,
      required: true,
    },

    nextSection: {
      type: String,
      default: null,
    },

    prevSection: {
      type: String,
      default: null,
    },
  },
  computed: {
    ...mapState(["submission", "team"]),

    rubricLink() {
      return getJudgingRubricLink(this.team.division);
    },
  },
};
</script>
