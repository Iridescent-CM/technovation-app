<template>
  <div />
</template>

<script>
import PieChart from '../../../components/PieChart'

export default {
  name: 'dashboard-section',

  components: {
    PieChart,
  },

  props: {
    chartEndpoints: {
      type: Object,
      default () {
        return {}
      },
    },

    totals: {
      type: Object,
      default () {
        return {}
      },
    },
  },

  created () {
    this.$store.commit('addChartEndpoints', this.chartEndpoints)
    this.$store.commit('addTotals', this.totals)
  },

  methods: {
    addChartDataToCache (payload) {
      this.$store.commit('addChartDataToCache', payload)
    },

    getTotal(name) {
      return this.$store.getters.getTotalByName(name)
    },
  }
}
</script>

<style scoped>
</style>