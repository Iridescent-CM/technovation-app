<template>
  <div class="certificate-button">
    <canvas :class="chartClasses"></canvas>
  </div>
</template>

<script>

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
  },

  mounted () {
    this.initializeChart()
  },

  // computed: {
  // },

  methods: {
    initializeChart () {
      if (this.chart !== null) {
        this.chart.destroy()
      }

      const chartElement = this.$el.querySelector('canvas')
      const chartContext = chartElement.getContext('2d')

      this.mutableChartData = Object.assign({}, defaultData, this.chartData)

      // Generate colors based on number of data items in the dataset
      Object.keys(this.mutableChartData.datasets).forEach((key) => {
        const numberOfDataItems = this.mutableChartData.datasets[key].data.length
        const backgroundColors = this.generateBackgroundColors(numberOfDataItems)

        // Set via Vue set method so we do not pollute the chartData prop
        this.$set(
          this.mutableChartData.datasets[key],
          'hoverBackgroundColor',
          backgroundColors.hoverBackgroundColor
        )
        this.$set(
          this.mutableChartData.datasets[key],
          'backgroundColor',
          backgroundColors.backgroundColor
        )
      })

      const { urls } = this.mutableChartData.datasets[0]

      if (typeof urls !== 'undefined' && urls.length > 0)
        chartElement.style.cursor = 'pointer'

      this.chart = new Chart(chartContext, {
        type: 'pie',
        data: this.mutableChartData,
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