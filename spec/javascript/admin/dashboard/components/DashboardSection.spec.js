import Vuex from 'vuex'
import { shallowMount, createLocalVue } from '@vue/test-utils'

import state from 'admin/dashboard/store/index'
import { __createMocks as createMocks } from 'admin/dashboard/store/__mocks__'

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
      totals: {
        mentors: 402,
        students: 876,
      },
    })

    const storeMocks = createMocks({
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
      PieChart,
    })
  })

  describe('methods', () => {

    describe('getTotal', () => {

      it('returns total for the given named index from vuex state', () => {
        const mentorsTotal = wrapper.vm.getTotal('mentors')
        const studentsTotal = wrapper.vm.getTotal('students')

        expect(mentorsTotal).toEqual(402)
        expect(studentsTotal).toEqual(876)
      })

    })

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

  })

})