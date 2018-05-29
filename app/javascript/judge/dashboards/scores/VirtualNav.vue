<template>
  <nav id="judge-dashboard-scores-nav">
    <router-link
      :to="{ name: 'finished-scores' }"
      :class="$route.name === 'finished-scores' ? 'active' : ''"
    >
      Finished scores
    </router-link>

    <router-link
      v-if="currentRound !== 'qf'"
      :to="{ name: 'qf-scores' }"
      :class="$route.name === 'qf-scores' ? 'active' : ''"
    >
      View your Quarterfinals Scores
    </router-link>
  </nav>
</template>

<script>
import { mapState } from 'vuex'

export default {
  computed: mapState(['currentRound']),
}
</script>
