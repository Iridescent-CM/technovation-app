<template>
  <div class="grid">
    <div class="grid__col-12 grid__col--bleed-y">
      <h2>Overall Impression</h2>
    </div>

    <team-info />

    <div class="grid__col-9 grid__col--bleed-y">
      <h1 class="border--b-thin-primary">{{ submission.name }}</h1>

      <div class="app-description" v-html="submission.description"></div>

      <question-section
        title="Overall Impression (25 points)"
        referTo="entire submission."
        prevSection="entrepreneurship"
        section="overall"
        nextSection="review-score"
        nextSectionTitle="Review score"
      >
        <p slot="comment-tips">
          Considering the native language and ages of the team,
          how does this submission stand out for you? How well
          do all the parts work together?
        </p>
      </question-section>
    </div>
  </div>
</template>

<script>
import { mapState } from 'vuex';

import TeamInfo from '../TeamInfo';
import QuestionSection from '../QuestionSection';

export default {
  components: {
    TeamInfo,
    QuestionSection,
  },

  computed: mapState(['submission']),
}
</script>
