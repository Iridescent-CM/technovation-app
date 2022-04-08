<template>
<!--  <div>-->
<!--    <EnergeticContainer heading="Project Name & Description">-->
<!--      <team-info />-->

<!--      <div>-->
<!--        <p class="font-bold text-lg">{{ submission.name }}</p>-->

<!--        <div class="app-description" v-html="submission.description"></div>-->

<!--        <ThickRule/>-->

<!--        <question-section-->
<!--            section="ideation"-->
<!--            nextSection="technical"-->
<!--        >-->
<!--          <p slot="section-summary" class="help-text">-->
<!--            To determine if the team has built a solution that will positively impact them and their community,-->
<!--            refer to all submission materials and the-->
<!--            <a target="_blank" href="http://technovation.staging.wpengine.com/wp-content/uploads/2021/03/ideation.png">rubric</a>.-->
<!--          </p>-->

<!--          <p slot="comment-tips">-->
<!--            Be sensitive to cultural differences and-->
<!--            focus on how well the team identified the problem-->
<!--            and presented a solution.-->
<!--          </p>-->
<!--        </question-section>-->
<!--      </div>-->
<!--    </EnergeticContainer>-->
<!--  </div>-->
    <div>
      <GenericJudgingContainer
          heading="Project Name & Description"
          section="ideation"
          next-section="technical"
      >
        <template v-slot:main-content>
          <p class="font-bold text-lg">{{ submission.name }}</p>
          <div v-html="submission.description"></div>
        </template>
      </GenericJudgingContainer>
    </div>
</template>

<script>
import TeamInfo from '../TeamInfo'
import Pitch from '../pieces/Pitch'
import QuestionSection from '../QuestionSection'
import EnergeticContainer from "../../components/EnergeticContainer";
import ThickRule from "../../components/ThickRule";

import { mapState } from 'vuex'
import GenericJudgingContainer from "../../components/GenericJudgingContainer";
import Template from "../../../components/job_process/template";

export default {
  computed: mapState(['submission']),

  components: {
    Template,
    QuestionSection,
    TeamInfo,
    Pitch,
    EnergeticContainer,
    ThickRule,
    GenericJudgingContainer
  },
}
</script>
