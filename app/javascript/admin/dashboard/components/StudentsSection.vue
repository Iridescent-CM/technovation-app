<template>
  <div class="tab-content" id="students">
    <h3>Students <span>([TODO POPULATE THIS WITH RESULTS])</span></h3>

    <h6>Parental permission</h6>

    <pie-chart :url="$store.state.chartEndpoints.permitted_students" />

    <h6>New vs. Returning</h6>

    <pie-chart
      :url="$store.state.chartEndpoints.returning_students"
      :color-range="{
        start: 'rgba(54, 162, 235, 1)',
        end: 'rgba(255, 206, 86, 1)',
      }"
    />
  </div>
</template>

<script>
import PieChart from '../../../components/PieChart'

export default {
  name: 'admin-dashboard-section-students',

  components: {
    PieChart,
  },
}
</script>

<style scoped>
</style>