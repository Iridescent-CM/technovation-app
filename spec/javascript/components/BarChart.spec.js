import { shallowMount } from '@vue/test-utils'
import axios from 'axios'

import BarChart from 'components/BarChart'

require('canvas')

describe('BarChart Vue component', () => {
  const htmlChartData = {
    labels: [ 'US', 'Spain', 'Mexico', 'Ethiopia', 'Germany', 'India' ],
    datasets: [
      {
        label: 'Students',
        data: [ 400, 500, 600, 900, 300, 100 ],
      },
      {
        label: 'Mentors',
        data: [ 100, 200, 300, 500, 100, 64 ],
      },
      {
        label: 'Judges',
        data: [ 20, 40, 60, 80, 10, 3 ],
      }
    ],
    urls: []
  }

  const jsonChartData = {
    data: {
      attributes: Object.assign({}, htmlChartData),
    },
  }

  const extendedChartData = Object.assign({}, htmlChartData)

  extendedChartData.datasets[0].backgroundColor = "rgba(250,250,110,0.7)"
  extendedChartData.datasets[1].backgroundColor = "rgba(0,0,255,0.7)"
  extendedChartData.datasets[2].backgroundColor = "rgba(42,72,88,0.7)"

  extendedChartData.datasets[0].hoverBackgroundColor = "rgba(250,250,110,1)"
  extendedChartData.datasets[1].hoverBackgroundColor = "rgba(0,0,255,1)"
  extendedChartData.datasets[2].hoverBackgroundColor = "rgba(42,72,88,1)"

  let wrapper

  beforeEach(() => {
    wrapper = shallowMount(BarChart, {
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
      expect(BarChart.props).toEqual({
        chartData: {
          type: Object,
          default: expect.any(Function),
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

    describe('chartClasses', () => {
      it('sets the quickview-charts class by default', () => {
        expect(BarChart.props.chartClasses.default())
          .toEqual({
            'quickview-charts': true,
          })
      })
    })

    describe('colorRange', () => {
      it('sets a light blue to light pink range by default', () => {
        expect(BarChart.props.colorRange.default())
          .toEqual({
            start: 'rgb(54, 162, 235)',
            end: 'rgb(255, 99, 132)',
          })
      })
    })

  })

  describe('data', () => {

    it('sets the correct initial state', () => {
      expect(BarChart.data()).toEqual({
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

      wrapper = shallowMount(BarChart, {
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

      wrapper = shallowMount(BarChart, {
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

        expect(wrapper.vm.chart.canvas).toEqual(chartElement)
        expect(wrapper.vm.chart.ctx).toEqual(chartContext)
        expect(wrapper.vm.chart.config).toEqual(
          expect.objectContaining({
            type: 'bar',
            data: expect.objectContaining(wrapper.vm.extendedChartData),
            options: expect.objectContaining({
              legend: expect.objectContaining({
                position: 'bottom',
                onHover: expect.any(Function),
              }),
              hover: expect.objectContaining({
                onHover: expect.any(Function),
              }),
              scales: expect.objectContaining({
                xAxes: [
                  expect.objectContaining({
                    stacked: true,
                  }),
                ],
                yAxes: [
                  expect.objectContaining({
                    stacked: true,
                  }),
                ]
              }),
            })
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

    describe('sortDataDescending', () => {

      it('should sort the labels, dataset data, and urls based on dataset totals', () => {
        const chartData = {
          labels: [ 'US', 'Spain', 'Mexico', 'Ethiopia', 'Germany', 'India' ],
          datasets: [
            {
              label: 'Students',
              data: [ 400, 500, 600, 900, 300, 100 ],
            },
            {
              label: 'Mentors',
              data: [ 100, 200, 300, 500, 104, 64 ],
            },
            {
              label: 'Judges',
              data: [ 20, 40, 60, 3, 10, 15 ],
            }
          ],
          urls: [
            [
              '/students/us/',
              '/students/es/',
              '/students/mx/',
              '/students/et/',
              '/students/de/',
              '/students/in/',
            ],
            [
              '/mentors/us/',
              '/mentors/es/',
              '/mentors/mx/',
              '/mentors/et/',
              '/mentors/de/',
              '/mentors/in/',
            ],
            [
              '/judges/us/',
              '/judges/es/',
              '/judges/mx/',
              '/judges/et/',
              '/judges/de/',
              '/judges/in/',
            ],
          ],
        }

        wrapper.vm.sortDataDescending(chartData)

        expect(chartData).toEqual({
          labels: [ 'Ethiopia', 'Mexico', 'Spain', 'US', 'Germany', 'India' ],
          datasets: [
            {
              label: 'Students',
              data: [ 900, 600, 500, 400, 300, 100 ],
            },
            {
              label: 'Mentors',
              data: [ 500, 300, 200, 100, 104, 64 ],
            },
            {
              label: 'Judges',
              data: [ 3, 60, 40, 20, 10, 15 ],
            }
          ],
          urls: [
            [
              '/students/et/',
              '/students/mx/',
              '/students/es/',
              '/students/us/',
              '/students/de/',
              '/students/in/',
            ],
            [
              '/mentors/et/',
              '/mentors/mx/',
              '/mentors/es/',
              '/mentors/us/',
              '/mentors/de/',
              '/mentors/in/',
            ],
            [
              '/judges/et/',
              '/judges/mx/',
              '/judges/es/',
              '/judges/us/',
              '/judges/de/',
              '/judges/in/',
            ],
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