<template>
  <div class="grid">
    <div class="grid__col-12 grid__col--bleed-y">
      <h2>Ideation</h2>
    </div>

    <team-info />

    <div class="grid__col-9 grid__col--bleed-y">
      <h1 class="border--b-thin-primary">{{ submission.name }}</h1>

      <div class="app-description" v-html="submission.description"></div>

      <div class="grid grid--bleed submission-pieces primary-row">
        <pitch :solo="true" />
      </div>

      <question-section
        title="Ideation (15 points)"
        referTo="app name and description, pitch video, and demo video."
        section="ideation"
        nextSection="technical"
      >
        <p slot="comment-tips">
          Be sensitive to cultural differences and
          focus on how well the team identified the problem
          and presented a solution.
        </p>
      </question-section>
    </div>
  </div>
</template>

<script>
import TeamInfo from '../TeamInfo'
import Pitch from '../pieces/Pitch'

import QuestionSection from '../QuestionSection'

import { mapState } from 'vuex'

export default {
  computed: mapState(['submission']),

  components: {
    QuestionSection,
    TeamInfo,
    Pitch,
  },
}
</script>
