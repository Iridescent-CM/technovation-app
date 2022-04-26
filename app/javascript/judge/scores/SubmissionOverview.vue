<template>
  <div>
    <p class="font-bold text-3xl">{{ team.name | capitalize}}</p>

    <div class="flex flex-col lg:flex-row gap-x-8 mt-4">
      <div class="w-full lg:w-1/4">
        <img class="h-full object-cover rounded-tr-2xl rounded-bl-2xl" :src="team.photo" alt="Team Photo"/>
      </div>

      <div class="mt-6">
        <p class="font-bold text-3xl text-energetic-blue rubik">{{ team.division | uppercase }} DIVISION</p>
        <p class="font-bold text-3xl text-energetic-blue rubik">{{ submission.development_platform }}</p>
        <p>
          <span><icon
              size="16"
              name="map-marker"
              class="inline"
              color="0075cf"
          />
          {{ team.location | capitalize }}</span>
        </p>
      </div>
    </div>

    <ThickRule/>

    <div class="mt-8">
      <p>You are reviewing a <span class="font-bold">{{ team.division | capitalize }} Division {{ submission.development_platform}}</span> submission.</p>
      <p>For tips on judging this category, click <a :href="rubricLink" class="tw-link" target="_blank">here</a>.</p>
    </div>

    <div class="mt-8 flex flex-col justify-center lg:flex-row lg:justify-between">
      <div v-if="score.incomplete">
        <p>
          <judge-recusal-popup cssClass="button button--danger">
            I cannot judge this submission
          </judge-recusal-popup>
        </p>
      </div>

      <div>
        <p>
          <router-link
              :to="{ name: 'project_details' }"
              class="tw-green-btn"
          >
            Start score
          </router-link>
        </p>
      </div>
    </div>
  </div>
</template>

<script>
import { mapState } from 'vuex'

import JudgeRecusalPopup from './JudgeRecusalPopup'
import Icon from '../../components/Icon'
import ThickRule from "../components/ThickRule";

export default {
  data() {
    return {
        devPlatform: null,
        submissionType: null
      }
  },
  computed: {
    ...mapState([
      'team',
      'score',
      'submission',
      'deadline',
    ],),

    emailSupport() {
      const subject = `Errors while judging submission "${this.submission.name}" by ${this.team.name}`

      return `mailto:${process.env.HELP_EMAIL}?subject=${subject}`
    },

    rubricLink () {
      switch (this.team.division) {
        case 'senior':
          return "https://technovationchallenge.org/wp-content/uploads/2021/09/Senior-Rubric-2022-Season-FINAL-9-14-21.pdf"
        case 'junior':
          return "https://technovationchallenge.org/wp-content/uploads/2021/09/Junior-Rubric-2022-Season-FINAL-9-14-21.pdf"
        case 'beginner':
          return "https://technovationchallenge.org/wp-content/uploads/2021/09/Beginner-Rubric-2022-Season-FINAL-9-14-21.pdf"
        default:
          return "https://technovationchallenge.org/curriculum/judging-rubric/"
      }
    }
  },
  components: {
    Icon,
    JudgeRecusalPopup,
    ThickRule
  }
}
</script>

<style scoped>
  h3 {
    font-size: 1.1rem;
  }

  ul {
    font-size: 0.9rem;
  }

  h6 {
    margin: 1rem 0 0;
  }
</style>
