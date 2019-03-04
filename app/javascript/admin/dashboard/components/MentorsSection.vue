<template>
  <div id="mentors">
    <h3>
      Mentors
      <span v-if="getTotal('mentors') && !hideTotal">
        ({{ getTotal('mentors') }})
      </span>
    </h3>

    <div class="tabs__tab-content">
      <h6>Onboarding</h6>

      <pie-chart
        :url="onboardingMentorsEndpoint"
        :chart-data="onboardingMentorsChartData"
        @pieChartInitialized="addChartDataToCache"
      />
    </div>

    <div class="tabs__tab-content">
      <h6>New vs. Returning</h6>

      <pie-chart
        :url="returningMentorsEndpoint"
        :chart-data="returningMentorsChartData"
        @pieChartInitialized="addChartDataToCache"
        :color-range="{
          start: 'rgba(54, 162, 235, 1)',
          end: 'rgba(255, 206, 86, 1)',
        }"
      />
    </div>
  </div>
</template>

<script>
import DashboardSection from './DashboardSection'

export default {
  name: 'mentors-section',

  extends: DashboardSection,

  computed: {
    onboardingMentorsEndpoint () {
      return this.$store.getters.getChartEndpoint('onboarding_mentors')
    },

    onboardingMentorsChartData () {
      return this.$store.getters.getCachedChartData('onboarding_mentors')
    },

    returningMentorsEndpoint () {
      return this.$store.getters.getChartEndpoint('returning_mentors')
    },

    returningMentorsChartData () {
      return this.$store.getters.getCachedChartData('returning_mentors')
    },
  },
}
</script>

<style scoped>
</style>