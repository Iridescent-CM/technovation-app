<template>
  <div id="participants">
    <h3>Participants<span v-if="getTotal('participants')"> ({{ getTotal('participants') }})</span></h3>

    <div class="tab-content">
      <bar-chart
        :url="participantsEndpoint"
        :chart-data="participantsChartData"
        @barChartInitialized="addChartDataToCache"
      />
    </div>
  </div>
</template>

<script>
import DashboardSection from './DashboardSection'

export default {
  name: 'participants-section',

  extends: DashboardSection,

  computed: {
    participantsEndpoint () {
      return this.$store.getters.getChartEndpoint('participants')
    },

    participantsChartData () {
      return this.$store.getters.getCachedChartData('participants')
    },
  },
}
</script>

<style scoped>
</style>