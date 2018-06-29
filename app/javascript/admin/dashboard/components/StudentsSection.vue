<template>
  <div id="students">
    <h3>Students <span v-if="showTotal">({{ getTotal('students') }})</span></h3>

    <div class="tab-content">
      <h6>Parental permission</h6>

      <pie-chart
        :url="$store.getters.getChartEndpoint('permitted_students')"
        :chart-data="$store.getters.getCachedChartData('permitted_students')"
        @pieChartInitialized="addChartDataToCache"
      />
    </div>

    <div class="tab-content">
      <h6>New vs. Returning</h6>

      <pie-chart
        :url="$store.getters.getChartEndpoint('returning_students')"
        :chart-data="$store.getters.getCachedChartData('returning_students')"
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
    showTotal () {
      return this.getTotal('students') !== null
    },
  },
}
</script>

<style scoped>
</style>