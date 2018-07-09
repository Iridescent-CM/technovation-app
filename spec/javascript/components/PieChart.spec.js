import { shallowMount } from '@vue/test-utils'
import axios from 'axios'

import PieChart from 'components/PieChart'

require('canvas')

describe('PieChart Vue component', () => {
  const htmlChartData = {
    labels: [
      'With parental permission – (75%)',
      'Without parental permission – (25%)',
    ],
    data: [
      3,
      1,
    ],
    urls: [
      '/with/parental/permission',
      '/without/parental/permission',
    ],
  }

  const jsonChartData = {
    data: {
      attributes: Object.assign({}, htmlChartData),
    },
  }

  const extendedChartData = Object.assign({}, htmlChartData)
  extendedChartData.backgroundColor = [
    "rgba(250,250,110,0.7)",
    "rgba(42,72,88,0.7)",
  ]
  extendedChartData.hoverBackgroundColor = [
    "rgba(250,250,110,1)",
    "rgba(42,72,88,1)",
  ]

  let wrapper

  beforeEach(() => {
    wrapper = shallowMount(PieChart, {
      propsData: {
        chartData: Object.assign({}, htmlChartData),
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
          default: expect.any(Function),
          validator: expect.any(Function),
        },

        chartClasses: {
          type: Object,
          default: expect.any(Function),
        },

        colorRange: {
          type: Object,
          default: expect.any(Function),
        },

        url: {
          type: String,
          default: '',
        },
      })
    })

    describe('chartData', () => {
      const labels = [ 'One', 'Two' ]
      const data = [ 1, 3 ]
      const urls = [ '/url/one', '/url/two' ]

      const invalidLabels = 'string'
      const invalidData = 'string'
      const invalidUrls = 'string'

      const dataWithoutLabels = { data, urls }
      const labelsWithoutData = { labels, urls }
      const labelsAndDataWithoutUrls = { labels, data }

      const dataWithInvalidLabels = {
        data,
        urls,
        labels: invalidLabels,
      }

      const labelsWithInvalidData = {
        labels,
        urls,
        data: invalidData,
      }

      const labelsAndDataWithInvalidUrls = {
        labels,
        data,
        urls: invalidUrls,
      }

      it('returns true if it is an empty object (needed for default value)', () => {
        expect(PieChart.props.chartData.validator({})).toBe(true)
      })

      it('returns true if label, data, and url props are present and arrays', () => {
        expect(PieChart.props.chartData.validator(htmlChartData)).toBe(true)
      })

      it('returns true if label and data props are present and arrays', () => {
        expect(PieChart.props.chartData.validator(labelsAndDataWithoutUrls))
          .toBe(true)
      })

      it('returns false if data is array and labels is not present', () => {
        expect(PieChart.props.chartData.validator(dataWithoutLabels))
          .toBe(false)
      })

      it('returns false if labels is array and data is not present', () => {
        expect(PieChart.props.chartData.validator(labelsWithoutData))
          .toBe(false)
      })

      it('returns false if labels is array and data is not an array', () => {
        expect(PieChart.props.chartData.validator(labelsWithInvalidData))
          .toBe(false)
      })

      it('returns false if data is array and labels is not an array', () => {
        expect(PieChart.props.chartData.validator(dataWithInvalidLabels))
          .toBe(false)
      })

      it('returns false if optional urls property is not an array', () => {
        expect(PieChart.props.chartData.validator(labelsAndDataWithInvalidUrls))
          .toBe(false)
      })

    })

    describe('chartClasses', () => {
      it('sets the quickview-charts class by default', () => {
        expect(PieChart.props.chartClasses.default())
          .toEqual({
            'quickview-charts': true,
          })
      })
    })

    describe('colorRange', () => {
      it('sets a light blue to light pink range by default', () => {
        expect(PieChart.props.colorRange.default())
          .toEqual({
            start: 'rgb(54, 162, 235)',
            end: 'rgb(255, 99, 132)',
          })
      })
    })

  })

  describe('data', () => {

    it('sets the correct initial state', () => {
      expect(PieChart.data()).toEqual({
        chart: null,
        loading: true,
        extendedChartData: {},
      })
    })

  })

  describe('mounted hook', () => {
    beforeEach(() => {
      axios.get.mockClear()
      axios.mockResponseOnce('get', jsonChartData)
    })

    it('loads the chart data via AJAX if chartData prop is empty and url is present', (done) => {
      expect(axios.get).not.toHaveBeenCalled()

      wrapper = shallowMount(PieChart, {
        propsData: {
          url: '/test/url',
          colorRange: {
            start: '#fafa6e',
            end: '#2A4858',
          },
        },
      })

      wrapper.vm.$nextTick(() => {
        expect(axios.get).toHaveBeenCalledWith('/test/url')
        expect(wrapper.vm.extendedChartData).toEqual(
          expect.objectContaining(extendedChartData)
        )
        done()
      })
    })

    it('loads the chart data from chartData prop if url is not present', (done) => {
      expect(axios.get).not.toHaveBeenCalled()

      wrapper = shallowMount(PieChart, {
        propsData: {
          chartData: Object.assign({}, htmlChartData),
          colorRange: {
            start: '#fafa6e',
            end: '#2A4858',
          },
        },
      })

      wrapper.vm.$nextTick(() => {
        expect(axios.get).not.toHaveBeenCalled()
        expect(wrapper.vm.extendedChartData).toEqual(
          expect.objectContaining(extendedChartData)
        )
        done()
      })
    })

  })

  describe('methods', () => {

    describe('initializeChart', () => {

      it('destroys the chart if already created', () => {
        const chartDestroySpy = spyOn(wrapper.vm.chart, 'destroy')

        expect(chartDestroySpy).not.toHaveBeenCalled()

        wrapper.vm.initializeChart(htmlChartData)

        expect(chartDestroySpy).toHaveBeenCalledTimes(1)
      })

      it('sets the extendedChartData by extending the chartData prop', () => {
        expect(wrapper.vm.extendedChartData).toEqual(
          expect.objectContaining(extendedChartData)
        )
      })

      it('creates a chart.js instance with the correct settings', () => {
        const chartElement = wrapper.find('canvas').element
        const chartContext = chartElement.getContext('2d')

        const {
          labels,
          data,
          backgroundColor,
          hoverBackgroundColor,
          urls
        } = wrapper.vm.extendedChartData

        expect(wrapper.vm.chart.canvas).toEqual(chartElement)
        expect(wrapper.vm.chart.ctx).toEqual(chartContext)
        expect(wrapper.vm.chart.config).toEqual(
          expect.objectContaining({
            type: 'pie',
            data: expect.objectContaining({
              labels,
              datasets: [
                expect.objectContaining({
                  data,
                  backgroundColor,
                  hoverBackgroundColor,
                  urls,
                })
              ],
            }),
            options: expect.objectContaining({
              legend: expect.objectContaining({
                position: 'bottom',
                onHover: expect.any(Function),
              }),
              hover: expect.objectContaining({
                onHover: expect.any(Function),
              }),
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

    describe('isEmptyObject', () => {

      it('returns true if object is empty', () => {
        const object = {}

        const result = wrapper.vm.isEmptyObject(object)

        expect(result).toBe(true)
      })

      it('returns false if the object is not empty', () => {
        const object = {
          key: 'value'
        }

        const result = wrapper.vm.isEmptyObject(object)

        expect(result).toBe(false)
      })

    })

  })

})