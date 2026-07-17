<template>
  <div class="pie-chart">
    <div v-if="loading">
      <app-icon class="spin" name="spinner" size="16" />

      <span>Loading chart...</span>
    </div>

    <canvas v-show="!loading" :class="chartClasses"></canvas>
  </div>
</template>

<script>
import AppIcon from "./AppIcon.vue";
import { isEmptyObject } from "../utilities/utilities";

export default {
  name: "PieChart",

  components: {
    AppIcon,
  },

  props: {
    chartData: {
      type: Object,
      default() {
        return {};
      },
      validator(chartData) {
        if (isEmptyObject(chartData)) return true;

        if (!(chartData.labels && chartData.labels.constructor === Array))
          return false;

        if (!(chartData.data && chartData.data.constructor === Array))
          return false;

        if (chartData.urls && chartData.urls.constructor !== Array)
          return false;

        return true;
      },
    },

    chartClasses: {
      type: Object,
      default() {
        return {
          "quickview-charts": true,
        };
      },
    },

    colorRange: {
      type: Object,
      default() {
        return {
          start: "rgb(54, 162, 235)",
          end: "rgb(255, 99, 132)",
        };
      },
    },

    url: {
      type: String,
      default: "",
    },
  },

  data() {
    return {
      chart: null,
      loading: true,
      extendedChartData: {},
    };
  },

  mounted() {
    this.loadChartLibraries().then(() => {
      if (this.url !== "" && this.isEmptyObject(this.chartData)) {
        window.axios.get(this.url).then((response) => {
          this.initializeChart(response.data.data.attributes);
        });
      } else {
        this.initializeChart(this.chartData);
      }
    });
  },

  methods: {
    isEmptyObject,

    async loadChartLibraries() {
      const [chartModule, chromaModule] = await Promise.all([
        import(/* webpackChunkName: "chartjs" */ "chart.js"),
        import(/* webpackChunkName: "chartjs" */ "chroma-js"),
      ]);

      await import(
        /* webpackChunkName: "chartjs" */ "../utilities/chartjs-plugins"
      );

      this.Chart = chartModule.default;
      this.chroma = chromaModule.default;
    },

    initializeChart(chartData) {
      if (this.chart !== null) {
        this.chart.destroy();
      }

      const chartContext = this.$el.querySelector("canvas").getContext("2d");

      const numberOfDataItems = chartData.data.length;
      const backgroundColors = this.generateBackgroundColors(numberOfDataItems);

      const extendedChartData = Object.assign({}, chartData, backgroundColors);

      this.chart = new this.Chart(chartContext, {
        type: "pie",
        data: {
          labels: extendedChartData.labels,
          datasets: [
            {
              data: extendedChartData.data,
              backgroundColor: extendedChartData.backgroundColor,
              hoverBackgroundColor: extendedChartData.hoverBackgroundColor,
              urls: extendedChartData.urls,
            },
          ],
        },
        options: {
          legend: {
            position: "bottom",
            onHover(e) {
              e.target.style.cursor = "pointer";
            },
          },
          hover: {
            onHover(e) {
              const point = this.getElementAtEvent(e);

              if (point.length) {
                e.target.style.cursor = "pointer";
              } else {
                e.target.style.cursor = "default";
              }
            },
          },
        },
      });

      this.$set(this, "extendedChartData", extendedChartData);

      // Emit event for caching AJAX response on the parent component
      this.$emit("pieChartInitialized", {
        url: this.url,
        chartData: this.extendedChartData,
      });

      this.loading = false;
    },

    generateBackgroundColors(numberOfColors) {
      const colorScale = this.chroma
        .scale([this.colorRange.start, this.colorRange.end])
        .mode("hsv")
        .colors(numberOfColors);

      const backgroundColors = {
        backgroundColor: [],
        hoverBackgroundColor: [],
      };

      colorScale.forEach((color) => {
        const hoverColorString = `rgba(${this.chroma(color)
          .alpha(1)
          .rgba()
          .join(",")})`;
        backgroundColors.hoverBackgroundColor.push(hoverColorString);

        const colorString = `rgba(${this.chroma(color)
          .alpha(0.7)
          .rgba()
          .join(",")})`;
        backgroundColors.backgroundColor.push(colorString);
      });

      return backgroundColors;
    },
  },
};
</script>

<style scoped></style>
