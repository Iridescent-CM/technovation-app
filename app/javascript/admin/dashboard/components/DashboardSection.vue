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
    },

    getTotal(name) {
      return this.$store.getters.getTotalByName(name)
    },
  }
}
</script>

<style scoped>
</style>