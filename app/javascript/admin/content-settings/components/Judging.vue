<template>
  <div id="judging">
    <h4>Judging Round</h4>
    <p class="inline-radio">
      <input
        id="season_toggles_judging_round_off"
        type="radio"
        value="off"
        v-model="$store.state.judging_round"
      >
      <label for="season_toggles_judging_round_off">Off</label>
    </p>
    <p class="inline-radio">
      <input
        id="season_toggles_judging_round_qf"
        type="radio"
        value="qf"
        v-model="$store.state.judging_round"
      >
      <label for="season_toggles_judging_round_qf">Quarterfinals</label>
    </p>
    <p class="inline-radio">
      <input
        id="season_toggles_judging_round_between"
        type="radio"
        value="between"
        v-model="$store.state.judging_round"
      >
      <label for="season_toggles_judging_round_between">Between rounds</label>
    </p>
    <p class="inline-radio">
      <input
        id="season_toggles_judging_round_sf"
        type="radio"
        value="sf"
        v-model="$store.state.judging_round"
      >
      <label for="season_toggles_judging_round_sf">Semifinals</label>
    </p>
    <p class="inline-radio">
      <input
        id="season_toggles_judging_round_finished"
        type="radio"
        value="finished"
        v-model="$store.state.judging_round"
      >
      <label for="season_toggles_judging_round_finished">Finished</label>
    </p>
    <div v-if="judgingEnabled" class="notice info hint">
      <icon name="exclamation-circle" :size="16" color="00529B" />
      Enabling judging has affected other season features.
    </div>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'

import Icon from 'components/Icon'

export default {
  name: 'judging-section',

  components: {
    Icon,
  },

  computed: {
    ...mapGetters([
      'judgingEnabled',
    ])
  },
}
</script>

<style scoped>
</style>