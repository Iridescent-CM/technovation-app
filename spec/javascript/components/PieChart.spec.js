import { shallow } from '@vue/test-utils'

import PieChart from 'components/PieChart'

describe('PieChart Vue component', () => {

  let wrapper

  beforeEach(() => {
    // TODO - Figure out how to get Canvas support into Jest before enabling this
    // wrapper = shallow(PieChart, {
    //   propsData: {
    //     chartData: {
    //       labels: [
    //         'With parental permission – (75%)',
    //         'Without parental permission – (25%)',
    //       ],
    //       datasets: [
    //         {
    //           data: [
    //             3,
    //             1,
    //           ],
    //           urls: [
    //             '/with/parental/permission',
    //             '/without/parental/permission',
    //           ],
    //         },
    //       ],
    //     },
    //     colorRange: {
    //       start: '#fafa6e',
    //       end: '#2A4858',
    //     },
    //   }
    // })
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

  xdescribe('methods', () => {

    describe('generateBackgroundColors', () => {

      // TODO - Figure out how to enable canvas support in Jest before enabling this
      it('returns RGBA background and hover color scales based on number of colors passed in', () => {
        const backgroundColors = wrapper.vm.generateBackgroundColors(6)

        expect(backgroundColors).toEqual({})
      })

    })

  })

})