<template>
  <div id="top-countries">
    <h3>
      Top Countries
      <span v-if="getTotal('top_countries') && !hideTotal">
        ({{ getTotal('top_countries') }})
      </span>
    </h3>

    <div class="tabs__tab-content">
      <bar-chart
        :url="topCountriesEndpoint"
        :chart-data="topCountriesChartData"
        @barChartInitialized="addChartDataToCache"
      />
    </div>
  </div>
</template>

<script>
import DashboardSection from './DashboardSection'

export default {
  name: 'top-countries-section',

  extends: DashboardSection,

  computed: {
    topCountriesEndpoint () {
      return this.$store.getters.getChartEndpoint('top_countries')
    },

    topCountriesChartData () {
      return this.$store.getters.getCachedChartData('top_countries')
    },
  },
}
</script>

<style scoped>
</style>