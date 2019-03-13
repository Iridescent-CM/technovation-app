<template>
  <div id="students">
    <h3>
      Students
      <span v-if="getTotal('students') && !hideTotal">
        ({{ getTotal('students') }})
      </span>
    </h3>

    <div class="tabs__tab-content">
      <h6>Onboarding</h6>

      <pie-chart
        :url="onboardingStudentsEndpoint"
        :chart-data="onboardingStudentsChartData"
        @pieChartInitialized="addChartDataToCache"
      />
    </div>

    <div class="tabs__tab-content">
      <h6>New vs. Returning</h6>

      <pie-chart
        :url="returningStudentsEndpoint"
        :chart-data="returningStudentsChartData"
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
  name: 'students-section',

  extends: DashboardSection,

  computed: {
    onboardingStudentsEndpoint () {
      return this.$store.getters.getChartEndpoint('onboarding_students')
    },

    onboardingStudentsChartData () {
      return this.$store.getters.getCachedChartData('onboarding_students')
    },

    returningStudentsEndpoint () {
      return this.$store.getters.getChartEndpoint('returning_students')
    },

    returningStudentsChartData () {
      return this.$store.getters.getCachedChartData('returning_students')
    },
  },
}
</script>

<style scoped>
</style>