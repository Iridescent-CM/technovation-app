<template>
  <div class="pie-chart">
    <div v-if="loading">
      <icon
        class="spin"
        name="spinner"
        size="16"
      />

      <span>Loading chart...</span>
    </div>

    <canvas v-show="!loading" :class="chartClasses"></canvas>
  </div>
</template>

<script>
import Chart from 'chart.js'
import chroma from 'chroma-js'

import Icon from './Icon.vue'
import '../utilities/chartjs-plugins'
import { isEmptyObject } from '../utilities/utilities'

export default {
  name: 'pie-chart',

  components: {
    Icon,
  },

  data () {
    return {
      chart: null,
      loading: true,
      extendedChartData: {},
    }
  },

  props: {
    chartData: {
      type: Object,
      default () {
        return {}
      },
      validator (chartData) {
        if (isEmptyObject(chartData))
          return true

        if (!(chartData.labels && chartData.labels.constructor === Array))
          return false

        if (!(chartData.data && chartData.data.constructor === Array))
          return false

        if (chartData.urls && chartData.urls.constructor !== Array)
          return false

        return true
      },
    },

    chartClasses: {
      type: Object,
      default () {
        return {
          'quickview-charts': true,
        }
      },
    },

    colorRange: {
      type: Object,
      default () {
        return {
          start: 'rgb(54, 162, 235)',
          end: 'rgb(255, 99, 132)',
        }
      },
    },

    url: {
      type: String,
      default: '',
    },
  },

  mounted () {
    if (this.url !== '' && this.isEmptyObject(this.chartData)) {
      window.axios.get(this.url)
        .then((response) => {
          this.initializeChart(response.data.data.attributes)
        })
    } else {
      this.initializeChart(this.chartData)
    }
  },

  methods: {
    isEmptyObject,

    initializeChart (chartData) {
      if (this.chart !== null) {
        this.chart.destroy()
      }

      const chartElement = this.$el.querySelector('canvas')
      const chartContext = chartElement.getContext('2d')

      const numberOfDataItems = chartData.data.length
      const backgroundColors = this.generateBackgroundColors(numberOfDataItems)

      const extendedChartData = Object.assign({}, chartData, backgroundColors)

      const { urls } = extendedChartData

      if (typeof urls !== 'undefined' && urls.length > 0)
        chartElement.style.cursor = 'pointer'

      this.chart = new Chart(chartContext, {
        type: 'pie',
        data: {
          labels: extendedChartData.labels,
          datasets: [
            {
              data: extendedChartData.data,
              backgroundColor: extendedChartData.backgroundColor,
              hoverBackgroundColor: extendedChartData.hoverBackgroundColor,
              urls: extendedChartData.urls,
            }
          ],
        },
        options: {
          legend: {
            position: 'bottom',
          },
          onClick: (evt, els) => {
            const i = els[0]._index

            if (typeof urls !== 'undefined' && urls.length > 0)
              window.location.href = urls[i]
          },
        },
      })

      this.$set(this, 'extendedChartData', extendedChartData)

      // Emit event for caching AJAX response on the parent component
      this.$emit('pieChartInitialized', {
        url: this.url,
        chartData: this.extendedChartData
      })

      this.loading = false
    },

    generateBackgroundColors (numberOfColors) {
      const colorScale = chroma
        .scale([
          this.colorRange.start,
          this.colorRange.end,
        ])
        .mode('hsv')
        .colors(numberOfColors)

      const backgroundColors = {
        backgroundColor: [],
        hoverBackgroundColor: [],
      }

      colorScale.forEach((color) => {
        const hoverColorString = `rgba(${chroma(color).alpha(1).rgba().join(',')})`
        backgroundColors.hoverBackgroundColor.push(hoverColorString)

        const colorString = `rgba(${chroma(color).alpha(0.7).rgba().join(',')})`
        backgroundColors.backgroundColor.push(colorString)
      })

      return backgroundColors
    },
  },
}
</script>

<style scoped>
</style>