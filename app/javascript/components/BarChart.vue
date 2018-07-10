<template>
  <div class="bar-chart">
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
  name: 'bar-chart',

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

      const numberOfDataItems = chartData.datasets.length
      const backgroundColors = this.generateBackgroundColors(numberOfDataItems)

      const extendedChartData = Object.assign({}, chartData)

      this.sortDataDescending(extendedChartData)

      extendedChartData.datasets.forEach((dataset, index) => {
        dataset.backgroundColor = backgroundColors.backgroundColor[index]
        dataset.hoverBackgroundColor = backgroundColors.hoverBackgroundColor[index]

        if (
          typeof extendedChartData.urls !== 'undefined'
          && typeof extendedChartData.urls[index] !== 'undefined'
        ) {
          dataset.urls = extendedChartData.urls[index]
        }
      })

      this.chart = new Chart(chartContext, {
        type: 'bar',
        data: extendedChartData,
        options: {
          legend: {
            position: 'bottom',
            onHover (e) {
              e.target.style.cursor = 'pointer'
            },
          },
          hover: {
            onHover (e) {
              const point = this.getElementAtEvent(e)

              if (point.length) {
                e.target.style.cursor = 'pointer'
              } else {
                e.target.style.cursor = 'default'
              }
            },
          },
          scales: {
            xAxes: [{
              stacked: true,
              ticks: {
                stepSize: 1,
                min: 0,
                autoSkip: false,
              }
            }],
            yAxes: [{
              stacked: true,
            }]
          },
        },
      })

      this.$set(this, 'extendedChartData', extendedChartData)

      // Emit event for caching AJAX response on the parent component
      this.$emit('barChartInitialized', {
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

    sortDataDescending (chartData) {
      // Get dataset totals so that we can sort them
      const totals = []
      chartData.datasets.forEach((dataset, datasetIndex) => {
        dataset.data.forEach((data, dataIndex) => {
          if (typeof totals[dataIndex] !== 'undefined') {
            totals[dataIndex] += data
          } else {
            totals[dataIndex] = data
          }
        })
      })

      // Get sorted indexes used to restructure the chart data object
      const sortedIndexes = []
      totals.forEach((total, index) => {
        sortedIndexes.push([index, total])
      })

      sortedIndexes
        .sort((a, b) => {
          return a[1] - b[1]
        })
        .reverse()

      // Sort the chart data according to the sorted indexes
      const labels = []
      const data = []
      const urls = []

      chartData.datasets.forEach((dataset, datasetIndex) => {
        data[datasetIndex] = []

        if (typeof chartData.urls[datasetIndex] !== 'undefined') {
          urls[datasetIndex] = []
        }

        sortedIndexes.forEach((indexValuePair, index) => {
          const sortedIndex = indexValuePair[0]

          labels[index] = chartData.labels[sortedIndex]
          data[datasetIndex][index] = dataset.data[sortedIndex]

          if (
            typeof chartData.urls[datasetIndex] !== 'undefined'
            && typeof chartData.urls[datasetIndex][sortedIndex] !== 'undefined'
          ) {
            urls[datasetIndex][index] = chartData.urls[datasetIndex][sortedIndex]
          }
        })

        dataset.data = data[datasetIndex]
      })

      chartData.labels = labels
      chartData.urls = urls
    },
  },
}
</script>

<style scoped>
</style>