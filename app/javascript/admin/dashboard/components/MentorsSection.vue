<template>
  <div class="tab-content" id="mentors">
    <h3>Mentors <span>([TODO POPULATE THIS WITH RESULTS])</span></h3>

    <h6>Background check / consent waivers</h6>

    <pie-chart :url="$store.state.chartEndpoints.onboarding_mentors" />

    <h6>New vs. Returning</h6>

    <pie-chart
      :url="$store.state.chartEndpoints.returning_mentors"
      :color-range="{
        start: 'rgba(54, 162, 235, 1)',
        end: 'rgba(255, 206, 86, 1)',
      }"
    />
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