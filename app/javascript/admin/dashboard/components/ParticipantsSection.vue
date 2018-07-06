<template>
  <div id="participants">
    <h3>Participants</h3>

    <div class="tab-content">
      <bar-chart
        :chart-data="{
          labels: [ 'US', 'Spain', 'Mexico', 'Ethiopia', 'Germany', 'India' ],
          datasets: [
            {
              label: 'Students',
              data: [ 400, 500, 600, 900, 300, 100 ],
            },
            {
              label: 'Mentors',
              data: [ 100, 200, 300, 500, 100, 64 ],
            },
            {
              label: 'Judges',
              data: [ 20, 40, 60, 80, 10, 3 ],
            }
          ]
        }"
      />
    </div>
  </div>
</template>

<script>
import DashboardSection from './DashboardSection'
import BarChart from '../../../components/BarChart'

export default {
  name: 'participants-section',

  extends: DashboardSection,

  components: {
    BarChart,
  },
}
</script>

<style scoped>
</style>