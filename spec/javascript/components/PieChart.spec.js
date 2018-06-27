import { shallow } from '@vue/test-utils'

import PieChart from 'components/PieChart'

require('canvas')

describe('PieChart Vue component', () => {

  let wrapper

  beforeEach(() => {
    wrapper = shallow(PieChart, {
      propsData: {
        chartData: {
          labels: [
            'With parental permission – (75%)',
            'Without parental permission – (25%)',
          ],
          datasets: [
            {
              data: [
                3,
                1,
              ],
              urls: [
                '/with/parental/permission',
                '/without/parental/permission',
              ],
            },
          ],
        },
        colorRange: {
          start: '#fafa6e',
          end: '#2A4858',
        },
      },
    })
  })

  describe('props', () => {

    it('contains valid props', () => {
      expect(PieChart.props).toEqual({
        chartData: {
          type: Object,
          required: true,
        },

        chartClasses: {
          type: Object,
          default: expect.any(Function)
        },

        colorRange: {
          type: Object,
          default: expect.any(Function)
        },
      })
    })

    it('chartClasses sets the quickview-charts class by default', () => {
      expect(PieChart.props.chartClasses.default())
        .toEqual({
          'quickview-charts': true,
        })
    })

    it('colorRange sets a light blue to light pink range by default', () => {
      expect(PieChart.props.colorRange.default())
        .toEqual({
          start: 'rgb(54, 162, 235)',
          end: 'rgb(255, 99, 132)',
        })
    })

  })

  describe('data', () => {

    it('sets the correct initial state', () => {
      expect(PieChart.data()).toEqual({
        chart: null,
        mutableChartData: {},
      })
    })

  })

  describe('methods', () => {

    describe('initializeChart', () => {

      it('destroys the chart if already created', () => {
        const chartDestroySpy = spyOn(wrapper.vm.chart, 'destroy')

        expect(chartDestroySpy).not.toHaveBeenCalled()

        wrapper.vm.initializeChart()

        expect(chartDestroySpy).toHaveBeenCalledTimes(1)
      })

      it('sets the mutableChartData by extending the chartData prop', () => {
        expect(wrapper.vm.mutableChartData).toEqual({
          labels: [
            'With parental permission – (75%)',
            'Without parental permission – (25%)',
          ],
          datasets: [
            expect.objectContaining({
              backgroundColor: [
                "rgba(250,250,110,0.7)",
                "rgba(42,72,88,0.7)",
              ],
              data: [
                3,
                1,
              ],
              hoverBackgroundColor: [
                "rgba(250,250,110,1)",
                "rgba(42,72,88,1)",
              ],
              urls: [
                '/with/parental/permission',
                '/without/parental/permission',
              ],
            })
          ],
        })
      })

      it('creates a chart.js instance with the correct settings', () => {
        const chartElement = wrapper.find('canvas').element
        const chartContext = chartElement.getContext('2d')

        expect(wrapper.vm.chart.canvas).toEqual(chartElement)
        expect(wrapper.vm.chart.ctx).toEqual(chartContext)
        expect(wrapper.vm.chart.config).toEqual(
          expect.objectContaining({
            type: 'pie',
            data: wrapper.vm.mutableChartData,
            options: expect.objectContaining({
              legend: expect.objectContaining({
                position: 'bottom',
              }),
              onClick: expect.any(Function),
            }),
          })
        )
      })
    })

    describe('generateBackgroundColors', () => {

      it('returns RGBA background and hover color scales based on number of colors passed in', () => {
        const backgroundColors = wrapper.vm.generateBackgroundColors(6)

        expect(backgroundColors).toEqual({
          backgroundColor: [
            'rgba(250,250,110,0.7)',
            'rgba(161,218,97,0.7)',
            'rgba(90,185,84,0.7)',
            'rgba(71,153,104,0.7)',
            'rgba(57,120,113,0.7)',
            'rgba(42,72,88,0.7)',
          ],
          hoverBackgroundColor: [
            'rgba(250,250,110,1)',
            'rgba(161,218,97,1)',
            'rgba(90,185,84,1)',
            'rgba(71,153,104,1)',
            'rgba(57,120,113,1)',
            'rgba(42,72,88,1)',
          ],
        })
      })

    })

  })

})