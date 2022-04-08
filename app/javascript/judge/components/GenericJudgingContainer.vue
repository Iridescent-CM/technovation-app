<template>
  <div>
    <EnergeticContainer :heading="heading">
      <TeamInfo />
      <div>
        <slot name="main-content"></slot>

        <ThickRule/>

        <question-section
            :prevSection="prevSection"
            :section="section"
            :nextSection="nextSection"
        >
          <p slot="section-summary" class="help-text">
            To determine if the team has built a solution that will positively impact them and their community,
            refer to all submission materials and the
            <a target="_blank" href="http://technovation.staging.wpengine.com/wp-content/uploads/2021/03/ideation.png">rubric</a>.
          </p>

          <p slot="comment-tips">
            Be sensitive to cultural differences and
            focus on how well the team identified the problem
            and presented a solution.
          </p>
        </question-section>
      </div>
    </EnergeticContainer>
  </div>
</template>


<script>
import TeamInfo from "../scores/TeamInfo";
import QuestionSection from "../scores/QuestionSection";
import EnergeticContainer from "./EnergeticContainer";
import ThickRule from "./ThickRule";
import {mapState} from "vuex";

export default {
  computed: mapState(['submission']),
  name: "GenericJudgingContainer",
  components: {
    TeamInfo,
    QuestionSection,
    EnergeticContainer,
    ThickRule
  },
  props: ['heading', 'section', 'nextSection', 'prevSection']
}
</script>
