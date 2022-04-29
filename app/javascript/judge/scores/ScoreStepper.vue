<template>
  <div class="lg:sticky lg:top-8 w-full lg:w-1/3 rounded-md border-solid border-4 border-energetic-blue h-fit-content">
    <div class="bg-energetic-blue text-white p-2">
      <p class="font-bold">Score</p>
    </div>

    <nav class="p-4">
      <ol role="list" class="overflow-hidden">
        <score-stepper-item
          section-name="overview"
          section-title="Overview"
          :is-active="$route.name === 'overview'"
          :is-complete="$route.name !== 'overview'"
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
          :section-score="`${totalScore} / ${totalPossibleScore}`"
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

    totalPossibleScore () {
      return this.$store.getters.totalPossibleScore
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
