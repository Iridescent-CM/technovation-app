<template>
  <div class="pie-chart">
    <p v-show="loading">Loading...</p>
    <canvas v-show="!loading" :class="chartClasses"></canvas>
  </div>
</template>

<script>

import axios from 'axios'
import Chart from 'chart.js'
import chroma from 'chroma-js'

const defaultData = {
  labels: [],
  datasets: [
    {
      data: [],
      backgroundColor: [],
      hoverBackgroundColor: [],
      urls: [],
    }
  ],
}

export default {
  name: 'pie-chart',

  data () {
    return {
      chart: null,
      loading: true,
      mutableChartData: {},
    }
  },

  props: {
    chartData: {
      type: Object,
      required: true,
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
      axios.get(this.url)
        .then(({ data }) => {
          this.initializeChart(data)
        })
    } else {
      this.initializeChart(this.chartData)
    }
  },

  methods: {
    initializeChart (chartData) {
      if (this.chart !== null) {
        this.chart.destroy()
      }

      const chartElement = this.$el.querySelector('canvas')
      const chartContext = chartElement.getContext('2d')

      const extendedChartData = Object.assign({}, defaultData, chartData)

      // Generate colors based on number of data items in the dataset
      Object.keys(extendedChartData.datasets).forEach((key) => {
        const numberOfDataItems = extendedChartData.datasets[key].data.length
        const backgroundColors = this.generateBackgroundColors(numberOfDataItems)

        extendedChartData.datasets[key].hoverBackgroundColor = backgroundColors.hoverBackgroundColor
        extendedChartData.datasets[key].backgroundColor = backgroundColors.backgroundColor
      })

      const { urls } = extendedChartData.datasets[0]

      if (typeof urls !== 'undefined' && urls.length > 0)
        chartElement.style.cursor = 'pointer'

      this.chart = new Chart(chartContext, {
        type: 'pie',
        data: extendedChartData,
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

      this.$set(this, 'mutableChartData', extendedChartData)

      // Emit event for caching AJAX response on the parent component
      this.$emit('pieChartInitialized', this.mutableChartData)

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

    isEmptyObject(object) {
      return Object.keys(object).length === 0 && object.constructor === Object
    },
  },
}
</script>

<style scoped>
</style>