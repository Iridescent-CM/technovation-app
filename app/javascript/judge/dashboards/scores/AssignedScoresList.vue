<template>
  <div class="margin-top-normal">
    <h6 class="heading--reset">
      Start scoring your assigned submissions
    </h6>

    <div
      class="grid grid--justify-space-between"
      v-for="submission in assignedSubmissions"
    >
      <div class="grid__col-5 grid__col--bleed-x">
        <small>Submission name</small>
        {{ submission.app_name }}
      </div>

      <div class="grid__col-5 grid__col--bleed-x">
        <small>{{ submission.team_division }} division team</small>
        {{ submission.team_name }}
      </div>

      <div class="grid__col-2 grid__col--bleed-x">
        <a
          :href="submission.new_score_url"
          class="button button--remove-bg"
        >
          {{ callToAction(submission) }}
        </a>
      </div>
    </div>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'

export default {
  computed: {
    ...mapGetters(['assignedSubmissions']),
  },

  methods: {
    callToAction (submission) {
      if (submission.score_started) {
        return 'Continue'
      } else if (submission.score_finished) {
        return 'Review'
      } else {
        return 'Start'
      }
    },
  },
}
</script>

<style scoped>
small {
  font-size: 0.8rem;
  font-weight: bold;
  text-transform: uppercase;
  color: #666;
}

.margin-top-normal {
  margin-top: 1rem;
}
</style>
