<template>
  <div id="judging">
    <h4>Judging Round</h4>
    <p class="inline-radio">
      <input
        id="season_toggles_judging_round_off"
        v-model="$store.state.judging_round"
        type="radio"
        value="off"
        :disabled="!isSuperAdmin"
      />
      <label for="season_toggles_judging_round_off">Off</label>
      <app-icon
        v-tooltip.right="'Before judging: Judges cannot judge'"
        name="question-circle"
        :size="16"
        color="00529B"
      />
    </p>
    <p class="inline-radio">
      <input
        id="season_toggles_judging_round_qf"
        v-model="$store.state.judging_round"
        type="radio"
        value="qf"
        :disabled="!isSuperAdmin"
      />
      <label for="season_toggles_judging_round_qf">Quarterfinals</label>
      <app-icon
        v-tooltip.right="
          'Judges can now judge either virtually or their assigned submissions'
        "
        name="question-circle"
        :size="16"
        color="00529B"
      />
    </p>
    <p class="inline-radio">
      <input
        id="season_toggles_judging_round_between"
        v-model="$store.state.judging_round"
        type="radio"
        value="between"
        :disabled="!isSuperAdmin"
      />
      <label for="season_toggles_judging_round_between">Between rounds</label>
      <app-icon
        v-tooltip.right="'Judges now see the &quot;between rounds&quot; screen'"
        name="question-circle"
        :size="16"
        color="00529B"
      />
    </p>
    <p class="inline-radio">
      <input
        id="season_toggles_judging_round_sf"
        v-model="$store.state.judging_round"
        type="radio"
        value="sf"
        :disabled="!isSuperAdmin"
      />
      <label for="season_toggles_judging_round_sf">Semifinals</label>
      <app-icon
        v-tooltip.right="'Judges can now judge semifinals submissions'"
        name="question-circle"
        :size="16"
        color="00529B"
      />
    </p>
    <p class="inline-radio">
      <input
        id="season_toggles_judging_round_finished"
        v-model="$store.state.judging_round"
        type="radio"
        value="finished"
        :disabled="!isSuperAdmin"
      />
      <label for="season_toggles_judging_round_finished">Finished</label>
      <app-icon
        v-tooltip.right="'After judging: judges cannot judge'"
        name="question-circle"
        :size="16"
        color="00529B"
      />
    </p>

    <p class="margin--t-large">
      <a
        href="https://docs.google.com/document/d/1bFN0yf2M0RrpdxBaq4tudNfhcvGetifY3v1gnHvkV20/"
        class="small"
        target="_blank"
        >View judging document</a
      >
    </p>

    <div v-if="judgingEnabled" class="notice info hint">
      <app-icon name="exclamation-circle" :size="16" color="00529B" />
      Enabling judging has affected other season features.
    </div>
  </div>
</template>

<script>
import { mapGetters } from "vuex";

import "components/tooltip.scss";
import AppIcon from "components/AppIcon";

export default {
  name: "JudgingSection",

  components: {
    AppIcon,
  },

  computed: {
    ...mapGetters(["judgingEnabled", "isSuperAdmin"]),
  },
};
</script>

<style scoped></style>
