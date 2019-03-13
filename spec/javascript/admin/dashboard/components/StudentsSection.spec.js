import Vuex from 'vuex'
import { shallowMount, createLocalVue } from '@vue/test-utils'

import state from 'admin/dashboard/store/state'
import mockStore from 'admin/dashboard/store/__mocks__'

import DashboardSection from 'admin/dashboard/components/DashboardSection'
import StudentsSection from 'admin/dashboard/components/StudentsSection'
import PieChart from 'components/PieChart'

const localVue = createLocalVue()

localVue.use(Vuex)

describe('Admin Dashboard - StudentsSection component', () => {

  let wrapper

  const onboardingStudents = {
    totals: {
      students: '854',
    },
    labels: [
      'Fully onboarded – (75%)',
      'Not fully onboarded – (25%)'
    ],
    data: [
      3,
      1,
    ],
    urls: [
      '/fully/onboarded',
      '/not/fully/onboarded',
    ]
  }

  const returningStudents = {
    totals: {
      students: '854',
    },
    labels: [
      'Returning students – (25%)',
      'New students – (75%)'
    ],
    data: [
      1,
      3,
    ],
  }

  beforeEach(() => {
    const initialState = Object.assign({}, state, {
      chartEndpoints: {
        'onboarding_students': '/onboarding/students',
        'returning_students': '/returning/students',
      },
      cachedStates: {
        '/onboarding/students': onboardingStudents,
        '/returning/students': returningStudents,
      },
    })

    const storeMocks = mockStore.createMocks({
      state: initialState,
    })

    wrapper = shallowMount(
      StudentsSection, {
        localVue,
        store: storeMocks.store,
      }
    )

    wrapper.vm.totals = onboardingStudents.totals
  })

  it('has a name attribute', () => {
    expect(StudentsSection.name).toEqual('students-section')
  })

  it('extends the DashboardSection component', () => {
    expect(StudentsSection.extends).toEqual(DashboardSection)
  })

  describe('computed properties', () => {

    describe('onboardingStudentsEndpoint', () => {

      it('returns an AJAX endpoint for the onboarding students chart', () => {
        expect(wrapper.vm.onboardingStudentsEndpoint)
          .toEqual('/onboarding/students')
      })

    })

    describe('onboardingStudentsChartData', () => {

      it('returns the cached chart data for the onboarding students chart', () => {
        expect(wrapper.vm.onboardingStudentsChartData)
          .toEqual(onboardingStudents)

        const initialState = Object.assign({}, state, {
          cachedStates: {},
        })

        const storeMocks = mockStore.createMocks({
          state: initialState,
        })

        wrapper = shallowMount(
          StudentsSection, {
            localVue,
            store: storeMocks.store,
          }
        )

        expect(wrapper.vm.onboardingStudentsChartData)
          .toEqual({})
      })

    })

    describe('returningStudentsEndpoint', () => {

      it('returns an AJAX endpoint for the returning students chart', () => {
        expect(wrapper.vm.returningStudentsEndpoint)
          .toEqual('/returning/students')
      })

    })

    describe('returningStudentsChartData', () => {

      it('returns the cached chart data for the returning students chart', () => {
        expect(wrapper.vm.returningStudentsChartData)
          .toEqual(returningStudents)

        const initialState = Object.assign({}, state, {
          cachedStates: {},
        })

        const storeMocks = mockStore.createMocks({
          state: initialState,
        })

        wrapper = shallowMount(
          StudentsSection, {
            localVue,
            store: storeMocks.store,
          }
        )

        expect(wrapper.vm.returningStudentsChartData)
          .toEqual({})
      })

    })

  })

  describe('HTML markup', () => {

    it('contains the correct markup', () => {
      expect(wrapper.element.getAttribute('id')).toEqual('students')

      expect(wrapper.find('h3 span').text()).toEqual('(854)')

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

    it('hides the students count label if the students total is not found', () => {
      wrapper.vm.totals = {}

      expect(wrapper.find('h3 span').exists()).toBe(false)
    })

    it('hides the students count label if the hideTotal prop is true', () => {
      wrapper.setProps({
        hideTotal: true,
      })

      expect(wrapper.find('h3 span').exists()).toBe(false)
    })

  })

})