import Vuex from 'vuex'
import { shallowMount, createLocalVue } from '@vue/test-utils'

import state from 'admin/dashboard/store/state'
import mockStore from 'admin/dashboard/store/__mocks__'

import BarChart from 'components/BarChart'
import PieChart from 'components/PieChart'
import DashboardSection from 'admin/dashboard/components/DashboardSection'

const localVue = createLocalVue()

localVue.use(Vuex)

describe('Admin Dashboard - DashboardSection component', () => {

  let wrapper

  beforeEach(() => {
    const initialState = Object.assign({}, state, {
      chartEndpoints: {
        'onboarding_mentors': '/onboarding/mentors',
      },
      cachedStates: {},
    })

    const storeMocks = mockStore.createMocks({
      state: initialState,
    })

    wrapper = shallowMount(
      DashboardSection, {
        localVue,
        store: storeMocks.store,
      }
    )
  })

  it('has a name attribute', () => {
    expect(DashboardSection.name).toEqual('dashboard-section')
  })

  it('uses the PieChart component', () => {
    expect(DashboardSection.components).toEqual({
      BarChart,
      PieChart,
    })
  })

  it('contains the proper default data', () => {
    expect(DashboardSection.data()).toEqual({
      totals: {},
    })
  })

  describe('props', () => {

    it('contains the proper properties used to populate the endpoints', () => {
      expect(DashboardSection.props).toEqual({
        chartEndpoints: {
          type: Object,
          default: expect.any(Function),
        },

        hideTotal: {
          type: Boolean,
          default: false,
        },
      })
    })

    describe('chartEndpoints', () => {

      it('returns an empty object by default', () => {
        expect(DashboardSection.props.chartEndpoints.default()).toEqual({})
      })

    })

  })

  describe('methods', () => {

    describe('addChartDataToCache', () => {

      it('commits the mutation to store the cache payload to the store', () => {
        const payload = {
          url: '/onboarding/mentors',
          chartData: {
            labels: [ 'One', 'Two' ],
            data: [ 1, 3 ],
            urls: [ '/one/', '/two/' ],
          },
        }

        spyOn(wrapper.vm.$store, 'commit')

        expect(wrapper.vm.$store.commit).not.toHaveBeenCalled()

        wrapper.vm.addChartDataToCache(payload)

        expect(wrapper.vm.$store.commit)
          .toHaveBeenCalledWith('addChartDataToCache', payload)
      })

    })

    describe('getTotal', () => {

      it('returns the total if it exists in the store', () => {
        wrapper.vm.totals = {
          students: '8436',
        }

        expect(wrapper.vm.getTotal('students')).toEqual('8436')

        wrapper.vm.totals.students = '0'

        expect(wrapper.vm.getTotal('students')).toEqual('0')
      })

      it('returns null if the total does not exist in the store', () => {
        wrapper.vm.totals = {}

        expect(wrapper.vm.getTotal('students')).toEqual(null)

        wrapper.vm.totals.students = null

        expect(wrapper.vm.getTotal('students')).toEqual(null)
      })

    })

  })

})