<template>
  <div />
</template>

<script>
import BarChart from '@appjs/components/BarChart'
import PieChart from '@appjs/components/PieChart'

export default {
  name: 'dashboard-section',

  components: {
    BarChart,
    PieChart,
  },

  data () {
    return {
      totals: {},
    }
  },

  props: {
    chartEndpoints: {
      type: Object,
      default () {
        return {}
      },
    },

    hideTotal: {
      type: Boolean,
      default: false,
    },
  },

  created () {
    this.$store.commit('addChartEndpoints', this.chartEndpoints)
  },

  methods: {
    addChartDataToCache (payload) {
      this.totals = payload.chartData.totals
      this.$store.commit('addChartDataToCache', payload)
    },

    getTotal(name) {
      if (typeof this.totals[name] !== 'undefined' && this.totals[name] !== null)
        return this.totals[name]

      return null
    },
  },
}
</script>

<style scoped>
</style>