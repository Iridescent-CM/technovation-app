<template>
  <div class="grid">
    <div class="grid__col-12 grid__col--bleed-y">
      <h2>Review submission</h2>
    </div>

    <team-info />

    <div class="grid__col-9 grid__col--bleed-y submission-review">
      <h1>{{ submission.name }}</h1>

      <div class="app-description" v-html="submission.description"></div>

      <screenshots />

      <div class="grid grid--bleed submission-pieces">
        <submission-pitch />

        <submission-code />

        <submission-business />

        <submission-presentation />
      </div>

      <submission-code-checklist />

      <div class="grid grid--bleed grid--justify-space-around">
        <div class="grid__col-12 grid--align-center">
          <hr />

          <h6>Notes for judges:</h6>

          <p class="scent--strong">
            If any part of the submission is broken, please
            <a :href="mailToHelp">email us</a> and complete
            as much of the score as you can. We will give the
            team a chance to correct any simple, technical mistakes.
            If the team is able to fix the issue, we will email you
            back and you will be able to update the score.
          </p>

          <p>
            Even after &#8220;finishing&#8221; a score,
            you have until May 20<sup>th</sup> to make changes.
            You may find that scoring a few submissions
            will help you calibrate your expectations.
          </p>

          <p>
            <router-link
              :to="{ name: 'ideation' }"
              class="button"
            >
              Start scoring
            </router-link>
          </p>

        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { mapState } from 'vuex'

import TeamInfo from './TeamInfo'
import Screenshots from './Screenshots'
import SubmissionPitch from './SubmissionPitch'
import SubmissionCode from './SubmissionCode'
import SubmissionBusiness from './SubmissionBusiness'
import SubmissionPresentation from './SubmissionPresentation'
import SubmissionCodeChecklist from './SubmissionCodeChecklist'

export default {
  computed: {
    ...mapState([
      'team',
      'submission',
    ]),

    mailToHelp () {
      return 'mailto:help@technovationchallenge.org?subject=' +
             'Errors while judging'
    },
  },

  components: {
    TeamInfo,
    Screenshots,
    SubmissionPitch,
    SubmissionCode,
    SubmissionBusiness,
    SubmissionPresentation,
    SubmissionCodeChecklist,
  },

  methods: {
  },
}
</script>

<style>
  #judge-scores-app h2 {
    margin: 1rem 0;
  }

  .app-description p {
    margin: 1rem 0;
  }

  .submission-review h1 {
    border-bottom: 1px solid #5ABF94;
  }

  .scent--strong a {
    color: black;
    font-weight: bold;
  }

  .scent--strong a:hover {
    text-decoration: underline;
  }

  .submission-pieces h4 {
    margin: 1rem 0 0.5rem;
  }
</style>
