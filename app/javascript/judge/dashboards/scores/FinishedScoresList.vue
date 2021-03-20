<template>
  <div id="finished-scores" class="margin-top-normal">
    <h6 class="heading--reset">
      Revise & review your finished

      <strong v-if="currentRound == 'qf'">quarterfinal</strong>
      <strong v-else>semifinal</strong>

      scores until <strong v-html="deadline"></strong>
    </h6>

    <template v-if="!finishedScores.length">
      <p>Finish a score and it will appear here for you to review</p>
    </template>

    <div
      class="grid grid--justify-space-between"
      v-for="score in finishedScores"
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
        <a :href="score.url" class="button button--remove-bg">
          Review
        </a>
      </div>
    </div>
  </div>
</template>

<script>
import { mapGetters, mapState } from 'vuex'

export default {
  computed: {
    ...mapGetters(['finishedScores']),
    ...mapState(['currentRound', 'deadline']),
  }
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
