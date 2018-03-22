<template>
  <div>
    <div
      class="grid grid--bleed grid--justify-space-between"
      v-for="score in finishedScores"
    >
      <div class="grid__col-4">
        <a :href="score.url" data-turbolinks="false">
          {{ score.submission_name }}
        </a>
      </div>

      <div class="grid__col-4">
        {{ score.team_name }}
      </div>

      <div class="grid__col-2">
        {{ score.team_division }}
      </div>

      <div class="grid__col-2">
        {{ score.total }} / {{ score.possible }}
      </div>
    </div>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'

export default {
  computed: mapGetters(['finishedScores']),
}
</script>
