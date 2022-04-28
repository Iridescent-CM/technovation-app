<template>
  <div class="sticky top-4 w-full lg:w-1/3 rounded-md border-solid border-4 border-energetic-blue h-fit-content">
    <div class="bg-energetic-blue text-white p-2">
      <p class="font-bold">Score Overview</p>
    </div>

    <nav class="p-4">
      <ol role="list" class="overflow-hidden">
        <score-stepper-item
          section-name="review-submission"
          section-title="Overview"
          :is-active="$route.name === 'review-submission'"
          :is-complete="hasScoreBeenStarted"
        />

        <score-stepper-item
          v-for="(section, i) in sections"
          :key="i"
          :section-name="section.name"
          :section-title="section.title"
          :section-score="`${section.pointsTotal} / ${section.pointsPossible}`"
          :is-active="$route.name === section.name"
          :is-complete="section.isComplete"
        />

        <score-stepper-item
          section-name="review-score"
          section-title="Review Score"
          :section-score="`${totalScore} / ${totalPossible}`"
          :is-active="$route.name === 'review-score'"
          :is-complete="isScoreComplete"
        />
      </ol>
    </nav>
  </div>
</template>

<script>
import ScoreStepperItem from './ScoreStepperItem'

export default {
  computed: {
    sections () {
      return this.$store.getters.sections
    },

    totalScore () {
      return this.$store.getters.totalScore
    },

    totalPossible () {
      return this.$store.getters.totalPossible
    },

    hasScoreBeenStarted () {
      return this.$store.getters.hasScoreBeenStarted
    },

    isScoreComplete () {
      return this.$store.getters.isScoreComplete
    }
  },

  components: {
    ScoreStepperItem
  }
}
</script>
