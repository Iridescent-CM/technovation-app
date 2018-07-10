<template>
  <div id="students">
    <h3>
      Students
      <span v-if="getTotal('students') && !hideTotal">
        ({{ getTotal('students') }})
      </span>
    </h3>

    <div class="tab-content">
      <h6>Parental permission</h6>

      <pie-chart
        :url="permittedStudentsEndpoint"
        :chart-data="permittedStudentsChartData"
        @pieChartInitialized="addChartDataToCache"
      />
    </div>

    <div class="tab-content">
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
    permittedStudentsEndpoint () {
      return this.$store.getters.getChartEndpoint('permitted_students')
    },

    permittedStudentsChartData () {
      return this.$store.getters.getCachedChartData('permitted_students')
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