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

  methods: {
    addChartDataToCache (payload) {
      this.$store.commit('addChartDataToCache', payload)
    }
  }
}
</script>

<style scoped>
</style>