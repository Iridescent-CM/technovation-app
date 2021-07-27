<template>
  <div class="margin-top-normal">
    <h6 class="heading--reset">
      Your scores from the quarterfinals
    </h6>

    <div
      class="grid grid--justify-space-between"
      v-for="score in finishedQuarterfinalsScores"
      :key="score.id"
    >
      <div class="grid__col-4 grid__col--bleed-x">
        <small>Submission name</small>
        {{ score.submission_name }}
      </div>

      <div class="grid__col-4 grid__col--bleed-x">
        <small>{{ score.team_division }} division team</small>
        {{ score.team_name }}
      </div>

      <div class="grid__col-2 grid__col--bleed-x">
        <small>Score given</small>
        {{ score.total }} / {{ score.total_possible }}
      </div>

      <div class="grid__col-2 grid__col--bleed-x">
        <a
          :href="`/judge/scores/${score.id}`"
        >View score</a>
      </div>
    </div>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'

export default {
  computed: mapGetters(['finishedQuarterfinalsScores']),
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
