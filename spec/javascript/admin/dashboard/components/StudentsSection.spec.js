import Vuex from 'vuex'
import { shallowMount, createLocalVue } from '@vue/test-utils'

import state from 'admin/dashboard/store/index'
import { __createMocks as createMocks } from 'admin/dashboard/store/__mocks__'

import DashboardSection from 'admin/dashboard/components/DashboardSection'
import StudentsSection from 'admin/dashboard/components/StudentsSection'
import PieChart from 'components/PieChart'

const localVue = createLocalVue()

localVue.use(Vuex)

describe('Admin Dashboard - StudentsSection component', () => {

  let wrapper

  const permittedStudents = {
    labels: [
      'With parental permission – (75%)',
      'Without parental permission – (25%)'
    ],
    data: [
      3,
      1,
    ],
    urls: [
      '/with/parental/permission',
      '/without/parental/permission',
    ]
  }

  const returningStudents = {
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
        'permitted_students': '/permitted/students',
        'returning_students': '/returning/students',
      },
      cachedStates: {
        '/permitted/students': permittedStudents,
        '/returning/students': returningStudents,
      },
      totals: {
        students: 854,
      },
    })

    const storeMocks = createMocks({
      state: initialState,
    })

    wrapper = shallowMount(
      StudentsSection, {
        localVue,
        store: storeMocks.store,
      }
    )
  })

  it('has a name attribute', () => {
    expect(StudentsSection.name).toEqual('students-section')
  })

  it('extends the DashboardSection component', () => {
    expect(StudentsSection.extends).toEqual(DashboardSection)
  })

  describe('computed properties', () => {

    describe('permittedStudentsEndpoint', () => {

      it('returns an AJAX endpoint for the permitted students chart', () => {
        expect(wrapper.vm.permittedStudentsEndpoint)
          .toEqual('/permitted/students')
      })

    })

    describe('permittedStudentsChartData', () => {

      it('returns the cached chart data for the permitted students chart', () => {
        expect(wrapper.vm.permittedStudentsChartData)
          .toEqual(permittedStudents)

        const initialState = Object.assign({}, state, {
          cachedStates: {},
        })

        const storeMocks = createMocks({
          state: initialState,
        })

        wrapper = shallowMount(
          StudentsSection, {
            localVue,
            store: storeMocks.store,
          }
        )

        expect(wrapper.vm.permittedStudentsChartData)
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

        const storeMocks = createMocks({
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

    describe('showTotal', () => {

      it('returns true if the students total does not equal null', () => {
        expect(wrapper.vm.$store.state.totals.students).toEqual(854)
        expect(wrapper.vm.showTotal).toEqual(true)

        const initialState = Object.assign({}, state, {
          totals: {
            students: 0,
          },
        })

        const storeMocks = createMocks({
          state: initialState,
        })

        const newWrapper = shallowMount(
          StudentsSection, {
            localVue,
            store: storeMocks.store,
          }
        )

        expect(newWrapper.vm.$store.state.totals.students).toEqual(0)
        expect(newWrapper.vm.showTotal).toEqual(true)
      })

      it('returns false if the students total does not equal null', () => {
        const initialState = Object.assign({}, state, {
          totals: {},
        })

        const storeMocks = createMocks({
          state: initialState,
        })

        wrapper = shallowMount(
          StudentsSection, {
            localVue,
            store: storeMocks.store,
          }
        )

        expect(wrapper.vm.$store.state.totals.students).not.toBeDefined()
        expect(wrapper.vm.showTotal).toEqual(false)
      })
    })
  })

  describe('HTML markup', () => {

    it('contains the correct markup', () => {
      expect(wrapper.element.getAttribute('id')).toEqual('students')
      expect(wrapper.find('h3').html())
        .toEqual('<h3>Students<span> (854)</span></h3>')

      const charts = wrapper.findAll('.tab-content')
      const onboardingChart = charts.at(0)
      const returningChart = charts.at(1)

      expect(onboardingChart.find('h6').text())
        .toEqual('Parental permission')
      expect(onboardingChart.find(PieChart).exists()).toBe(true)

      expect(returningChart.find('h6').text())
        .toEqual('New vs. Returning')
      expect(returningChart.find(PieChart).exists()).toBe(true)
    })

    it('hides the students count label if the students total is not found', () => {
      const initialState = Object.assign({}, state, {
        totals: {},
      })

      const storeMocks = createMocks({
        state: initialState,
      })

      wrapper = shallowMount(
        StudentsSection, {
          localVue,
          store: storeMocks.store,
        }
      )

      expect(wrapper.find('h3').html())
        .toEqual('<h3>Students<!----></h3>')
    })

  })

})