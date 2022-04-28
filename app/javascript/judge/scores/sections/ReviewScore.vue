<template>
  <div>
    <EnergeticContainer heading="Review Score">
      <TeamInfo/>
      <ThickRule/>
      <div class="w-full lg:w-1/2 mx-auto">
        <div v-for="section in sections" class="odd:bg-gray-200 p-6">
          <router-link
          :to="{ name: section.name }"
          v-tooltip.top-center="`Make changes to your ${section.title} score`"
          :key="section.name"
        >
          <div>
            <p class="flex">
              <icon
                v-if="problemInSection(section.name)"
                :alt="`Problem indicated in ${section.title}`"
                :title="`Problem indicated in ${section.title}`"
                name="exclamation-triangle"
                color="d0006f"
                size="18"
                class-name="mr-4"
              />
              <span class="font-bold">{{ section.title | capitalize }}</span>
            </p>
          </div>
          <div class="font-bold text-4xl text-center">
            {{ sectionPointsTotal(section.name) }}
          </div>
        </router-link>
        </div>

        <div class="p-6">
          <p class="font-bold">Final Total Score</p>
          <p class="text-center font-bold text-4xl">{{ totalScore }}</p>
        </div>

        <p class="mt-8 text-center" v-tooltip.top-center="finishScoreTooltip">
          <a
            :href="`/judge/score_completions?id=${score.id}`"
            :disabled="isScoreIncomplete"
            :class="isScoreIncomplete ? 'opacity-50 cursor-not-allowed pointer-events-none' : ''"
            class="tw-green-btn"
            data-method="post"
          >
            Finish Score
          </a>
        </p>
      </div>
    </EnergeticContainer>
  </div>
</template>

<script>
import { mapState, mapGetters, mapActions } from 'vuex'

import Icon from '../../../components/Icon'
import EnergeticContainer from "../../components/EnergeticContainer";
import TeamInfo from "../TeamInfo";
import ThickRule from "../../components/ThickRule";

export default {
  components: {
    Icon,
    EnergeticContainer,
    TeamInfo,
    ThickRule
  },

  created () {
    this.validateScore()
  },

  methods: {
    ...mapActions(['validateScore']),
  },

  computed: {
    ...mapState(['team', 'score', 'submission', 'deadline']),

    ...mapGetters([
      'hasIncompleteSections',
      'sectionPointsTotal',
      'totalScore',
      'problemInSection'
    ]),

    sections () {
      return this.$store.getters.sections
    },

    isScoreIncomplete () {
      return this.hasIncompleteSections
    },

    finishScoreTooltip () {
      if (this.isScoreIncomplete) {
        return 'Your score is not ready to be finished. ' +
               'Enter a score for each question, and a ' +
               'friendly, sufficient comment for each section'
      } else {
        return 'You can revisit your finished scores ' +
               'and make changes through ' + this.deadline + '.'
      }
    },
  },

  watch: {
    '$route': 'validateScore',
    score: 'validateScore'
  },
}
</script>
