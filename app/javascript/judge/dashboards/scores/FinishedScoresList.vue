<template>
  <div>
    <h6 class="heading--reset">Review your finished scores</h6>

    <div
      class="grid grid--justify-space-between"
      v-for="score in finishedScores"
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
        {{ score.total }} / {{ score.possible }}
      </div>

      <div class="grid__col-2 grid__col--bleed-x">
        <a :href="score.url" class="button button--remove-bg">
          Review score
        </a>
      </div>
    </div>

    <hr />
  </div>
</template>

<script>
import { mapGetters } from 'vuex'

export default {
  computed: mapGetters(['finishedScores']),
}
</script>

<style scoped>
small {
  font-size: 0.8rem;
  font-weight: bold;
  text-transform: uppercase;
  color: #666;
}
</style>
