import Vuex from 'vuex'
import { shallowMount, createLocalVue } from '@vue/test-utils'

import state from 'admin/dashboard/store/state'
import mockStore from 'admin/dashboard/store/__mocks__'

import DashboardSection from 'admin/dashboard/components/DashboardSection'
import MentorsSection from 'admin/dashboard/components/MentorsSection'
import PieChart from 'components/PieChart'

const localVue = createLocalVue()

localVue.use(Vuex)

describe('Admin Dashboard - MentorSection component', () => {

  let wrapper

  const onboardingMentors = {
    totals: {
      mentors: '402',
    },
    labels: [
      'Fully onboarded - (75%)',
      'Not fully onboarded - (25%)',
    ],
    data: [
      1,
      0,
    ],
    urls: [
      '/fully/onboarded/',
      '/not/fully/onboarded/',
    ],
  }

  const returningMentors = {
    totals: {
      mentors: '402',
    },
    labels: [
      'Returning mentors – (25%)',
      'New mentors – (75%)',
    ],
    data: [
      1,
      3,
    ],
  }

  beforeEach(() => {
    const initialState = Object.assign({}, state, {
      chartEndpoints: {
        'onboarding_mentors': '/onboarding/mentors',
        'returning_mentors': '/returning/mentors',
      },
      cachedStates: {
        '/onboarding/mentors': onboardingMentors,
        '/returning/mentors': returningMentors,
      },
    })

    const storeMocks = mockStore.createMocks({
      state: initialState,
    })

    wrapper = shallowMount(
      MentorsSection, {
        localVue,
        store: storeMocks.store,
      }
    )

    wrapper.vm.totals = onboardingMentors.totals
  })

  it('has a name attribute', () => {
    expect(MentorsSection.name).toEqual('mentors-section')
  })

  it('extends the DashboardSection component', () => {
    expect(MentorsSection.extends).toEqual(DashboardSection)
  })

  describe('computed properties', () => {

    describe('onboardingMentorsEndpoint', () => {

      it('returns an AJAX endpoint for the onboarding mentors chart', () => {
        expect(wrapper.vm.onboardingMentorsEndpoint)
          .toEqual('/onboarding/mentors')
      })

    })

    describe('onboardingMentorsChartData', () => {

      it('returns the cached chart data for the onboarding mentors chart', () => {
        expect(wrapper.vm.onboardingMentorsChartData)
          .toEqual(onboardingMentors)

        const initialState = Object.assign({}, state, {
          cachedStates: {},
        })

        const storeMocks = mockStore.createMocks({
          state: initialState,
        })

        wrapper = shallowMount(
          MentorsSection, {
            localVue,
            store: storeMocks.store,
          }
        )

        expect(wrapper.vm.onboardingMentorsChartData)
          .toEqual({})
      })

    })

    describe('returningMentorsEndpoint', () => {

      it('returns an AJAX endpoint for the returning mentors chart', () => {
        expect(wrapper.vm.returningMentorsEndpoint)
          .toEqual('/returning/mentors')
      })

    })

    describe('returningMentorsChartData', () => {

      it('returns the cached chart data for the returning mentors chart', () => {
        expect(wrapper.vm.returningMentorsChartData)
          .toEqual(returningMentors)

        const initialState = Object.assign({}, state, {
          cachedStates: {},
        })

        const storeMocks = mockStore.createMocks({
          state: initialState,
        })

        wrapper = shallowMount(
          MentorsSection, {
            localVue,
            store: storeMocks.store,
          }
        )

        expect(wrapper.vm.returningMentorsChartData)
          .toEqual({})
      })

    })

  })

  describe('HTML markup', () => {

    it('contains the correct markup', () => {
      expect(wrapper.element.getAttribute('id')).toEqual('mentors')

      expect(wrapper.find('h3 span').text()).toEqual('(402)')

      const charts = wrapper.findAll('.tabs__tab-content')
      const onboardingChart = charts.at(0)
      const returningChart = charts.at(1)

      expect(onboardingChart.find('h6').text())
        .toEqual('Onboarding')
      expect(onboardingChart.find(PieChart).exists()).toBe(true)

      expect(returningChart.find('h6').text())
        .toEqual('New vs. Returning')
      expect(returningChart.find(PieChart).exists()).toBe(true)
    })

    it('hides the mentors count label if the mentors total is not found', () => {
      wrapper.vm.totals = {}

      expect(wrapper.find('h3 span').exists()).toBe(false)
    })

    it('hides the mentors count label if the hideTotal prop is true', () => {
      wrapper.setProps({
        hideTotal: true,
      })

      expect(wrapper.find('h3 span').exists()).toBe(false)
    })

  })

})