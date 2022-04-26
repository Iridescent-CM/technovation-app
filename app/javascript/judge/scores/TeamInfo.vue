<template>
  <div class="mb-10">
    <p class="font-bold text-3xl">{{ team.name | capitalize}}</p>
    <div class="flex flex-col lg:flex-row gap-x-8 mt-4">
      <div class="w-full lg:w-1/4">
        <img class="h-full object-cover rounded-tr-2xl rounded-bl-2xl" :src="team.photo" alt="Team Photo"/>
      </div>

      <div class="mt-6">
        <p class="font-bold text-3xl text-energetic-blue rubik">{{ team.division | uppercase }} DIVISION</p>
        <p class="font-bold text-3xl text-energetic-blue rubik">{{ submission.development_platform }}</p>
        <p class="mt-4">
          <span><icon
              size="20"
              name="map-marker"
              class="inline"
              color="0075cf"
          />
          {{ team.location | capitalize }}</span>
        </p>
        <p>
          <span><icon
              size="18"
              name="file-o"
              class="inline"
              color="0075cf"
          />
            <a :href="rubricLink" class="font-bold text-tg-magenta" target="_blank">View</a>
             {{ team.division }} division judging rubric
          </span>
        </p>
      </div>
    </div>
  </div>

</template>

<script>
import { mapState } from 'vuex'

import JudgeRecusalPopup from './JudgeRecusalPopup'
import Icon from '../../components/Icon'

export default {
  computed: {
    ...mapState([
      'team',
      'score',
      'submission',
      'deadline',
    ]),

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
    JudgeRecusalPopup
  },
}
</script>