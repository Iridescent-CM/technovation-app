<template>
  <div class="grid">
      <div class="grid__col-12 grid__col--bleed-y">
        <h2>Entrepreneurship</h2>
      </div>

      <team-info />

      <div class="grid__col-9 grid__col--bleed-y">
        <h1 class="border--b-thin-primary">{{ submission.name }}</h1>

        <div class="app-description" v-html="submission.description"></div>

        <div class="grid grid--bleed submission-pieces white-row">
          <business />
        </div>

        <div class="grid grid--bleed submission-pieces primary-row">
          <pitch :solo="true" />
        </div>

        <question-section
          prevSection="pitch"
          section="entrepreneurship"
          nextSection="overall"
        >
          <p slot="section-summary" class="help-text">
            To judge how well a team has planned their business, please refer to all submission
            elements, particularly the business plan, and the
            <a target="_blank" href="https://technovationchallenge.org/wp-content/uploads/2019/10/Entrepreneurship.png">rubric</a>.
          </p>

          <p slot="comment-tips">
            How well the team did in developing a business.
            Like the technical section, entrepreneurship is not
            about how complex the business plan is, but how
            well the business meets the needs outlined by the team.
          </p>
        </question-section>
      </div>
  </div>
</template>

<script>
import { mapState } from 'vuex'

import TeamInfo from '../TeamInfo'
import Pitch from '../pieces/Pitch'
import Business from '../pieces/Business'

import QuestionSection from '../QuestionSection'

export default {
  computed: mapState(['submission']),

  components: {
    TeamInfo,
    Pitch,
    Business,
    QuestionSection,
  },
}
</script>
