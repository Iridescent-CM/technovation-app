import Vuex from 'vuex'
import { shallowMount, createLocalVue } from '@vue/test-utils'

import state from 'admin/dashboard/store/state'
import mockStore from 'admin/dashboard/store/__mocks__'

import DashboardSection from 'admin/dashboard/components/DashboardSection'
import TopCountriesSection from 'admin/dashboard/components/TopCountriesSection'
import BarChart from 'components/BarChart'

const localVue = createLocalVue()

localVue.use(Vuex)

describe('Admin Dashboard - TopCountriesSection component', () => {

  let wrapper

  const topCountries = {
    totals: {
      top_countries: '19,765',
    },
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
    ]
  }

  beforeEach(() => {
    const initialState = Object.assign({}, state, {
      chartEndpoints: {
        'top_countries': '/top_countries/endpoint',
      },
      cachedStates: {
        '/top_countries/endpoint': topCountries,
      },
    })

    const storeMocks = mockStore.createMocks({
      state: initialState,
    })

    wrapper = shallowMount(
      TopCountriesSection, {
        localVue,
        store: storeMocks.store,
      }
    )

    wrapper.vm.totals = topCountries.totals
  })

  it('has a name attribute', () => {
    expect(TopCountriesSection.name).toEqual('top-countries-section')
  })

  it('extends the DashboardSection component', () => {
    expect(TopCountriesSection.extends).toEqual(DashboardSection)
  })

  describe('computed properties', () => {

    describe('topCountriesEndpoint', () => {

      it('returns an AJAX endpoint for the top countries chart', () => {
        expect(wrapper.vm.topCountriesEndpoint)
          .toEqual('/top_countries/endpoint')
      })

    })

    describe('topCountriesChartData', () => {

      it('returns the cached chart data for the top countries chart', () => {
        expect(wrapper.vm.topCountriesChartData)
          .toEqual(topCountries)

        const initialState = Object.assign({}, state, {
          cachedStates: {},
        })

        const storeMocks = mockStore.createMocks({
          state: initialState,
        })

        wrapper = shallowMount(
          TopCountriesSection, {
            localVue,
            store: storeMocks.store,
          }
        )

        expect(wrapper.vm.topCountriesChartData)
          .toEqual({})
      })

    })

  })

  describe('HTML markup', () => {

    it('contains the correct markup', () => {
      expect(wrapper.element.getAttribute('id')).toEqual('top-countries')

      expect(wrapper.find('h3 span').text()).toEqual('(19,765)')

      expect(wrapper.find(BarChart).exists()).toBe(true)
    })

    it('hides the top countries count label if the top countries total is not found', async () => {
      wrapper.vm.totals = {}

      await wrapper.vm.$nextTick()

      expect(wrapper.find('h3 span').exists()).toBe(false)
    })

    it('hides the top countries count label if the hideTotal prop is true', async () => {
      wrapper.setProps({
        hideTotal: true,
      })

      await wrapper.vm.$nextTick()

      expect(wrapper.find('h3 span').exists()).toBe(false)
    })

  })

})
