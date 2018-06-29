<template>
  <div id="mentors">
    <h3>Mentors <span>([TODO POPULATE THIS WITH RESULTS])</span></h3>

    <div class="tab-content">
      <h6>Background check / consent waivers</h6>

      <pie-chart
        :url="$store.getters.getChartEndpoint('onboarding_mentors')"
        :chart-data="$store.getters.getCachedChartData('onboarding_mentors')"
        @pieChartInitialized="addChartDataToCache"
      />
    </div>

    <div class="tab-content">
      <h6>New vs. Returning</h6>

      <pie-chart
        :url="$store.getters.getChartEndpoint('returning_mentors')"
        :chart-data="$store.getters.getCachedChartData('returning_mentors')"
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
}
</script>

<style scoped>
</style>