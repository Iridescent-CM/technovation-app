<template>
  <div />
</template>

<script>
export default {
  name: "DashboardSection",

  props: {
    chartEndpoints: {
      type: Object,
      default() {
        return {};
      },
    },

    hideTotal: {
      type: Boolean,
      default: false,
    },
  },

  data() {
    return {
      totals: {},
    };
  },

  created() {
    this.$store.commit("addChartEndpoints", this.chartEndpoints);
  },

  methods: {
    addChartDataToCache(payload) {
      this.totals = payload.chartData.totals;
      this.$store.commit("addChartDataToCache", payload);
    },

    getTotal(name) {
      if (
        typeof this.totals[name] !== "undefined" &&
        this.totals[name] !== null
      )
        return this.totals[name];

      return null;
    },
  },
};
</script>

<style scoped></style>
