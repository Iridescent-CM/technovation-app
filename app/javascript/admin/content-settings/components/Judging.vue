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
      <icon name="question-circle" :size="16" color="00529B" v-tooltip.right="'Before judging: Judges cannot judge'" />
    </p>
    <p class="inline-radio">
      <input
        id="season_toggles_judging_round_qf"
        type="radio"
        value="qf"
        v-model="$store.state.judging_round"
      >
      <label for="season_toggles_judging_round_qf">Quarterfinals</label>
      <icon name="question-circle" :size="16" color="00529B" v-tooltip.right="'Judges can now judge either virtually or their assigned submissions'" />
    </p>
    <p class="inline-radio">
      <input
        id="season_toggles_judging_round_between"
        type="radio"
        value="between"
        v-model="$store.state.judging_round"
      >
      <label for="season_toggles_judging_round_between">Between rounds</label>
      <icon name="question-circle" :size="16" color="00529B" v-tooltip.right="'Judges now see the &quot;between rounds&quot; screen'" />
    </p>
    <p class="inline-radio">
      <input
        id="season_toggles_judging_round_sf"
        type="radio"
        value="sf"
        v-model="$store.state.judging_round"
      >
      <label for="season_toggles_judging_round_sf">Semifinals</label>
      <icon name="question-circle" :size="16" color="00529B" v-tooltip.right="'Judges can now judge semifinals submissions'" />
    </p>
    <p class="inline-radio">
      <input
        id="season_toggles_judging_round_finished"
        type="radio"
        value="finished"
        v-model="$store.state.judging_round"
      >
      <label for="season_toggles_judging_round_finished">Finished</label>
      <icon name="question-circle" :size="16" color="00529B" v-tooltip.right="'After judging: judges cannot judge'" />
    </p>

    <p class="margin--t-large">
      <a href="https://docs.google.com/document/d/1bFN0yf2M0RrpdxBaq4tudNfhcvGetifY3v1gnHvkV20/" class="small" target="_blank">View judging document</a>
    </p>

    <div v-if="judgingEnabled" class="notice info hint">
      <icon name="exclamation-circle" :size="16" color="00529B" />
      Enabling judging has affected other season features.
    </div>
  </div>
</template>

<script>
import { VTooltip } from 'v-tooltip'
import { mapGetters } from 'vuex'

import 'components/tooltip.scss'
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
