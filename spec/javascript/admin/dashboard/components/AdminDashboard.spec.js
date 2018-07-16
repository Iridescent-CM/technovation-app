import axios from 'axios'
import Vuex from 'vuex'
import VueRouter from 'vue-router'
import { shallowMount, createLocalVue } from '@vue/test-utils'

import mockStore from 'admin/dashboard/store/__mocks__'
import { router } from 'admin/dashboard/routes'

import AdminDashboard from 'admin/dashboard/components/AdminDashboard'

const localVue = createLocalVue()

localVue.use(VueRouter)
localVue.use(Vuex)

describe('Admin Dashboard - AdminDashboard component', () => {

  let wrapper

  const chartEndpoints = {
    permitted_students: '/permitted/students/',
    returning_students: '/returning/students/',
    onboarding_mentors: '/onboarding/mentors/',
    returning_mentors: '/returning/mentors/',
  }

  const totals = {
    mentors: 789,
    students: 4682,
  }

  const store = mockStore.createMocks().store

  beforeEach(() => {
    axios.mockResponse('get', {
      data: {
        attributes: {
          labels: [ 'One', 'Two' ],
          data: [ 1, 3 ],
          urls: [ '/one', '/two' ],
        },
      },
    })

    wrapper = shallowMount(
      AdminDashboard, {
        localVue,
        router,
        store,
        propsData: {
          chartEndpoints,
          totals,
        }
      }
    )
  })

  it('has a name attribute', () => {
    expect(AdminDashboard.name).toEqual('admin-dashboard')
  })

  describe('props', () => {

    it('contains the proper properties used to populate the endpoints and totals', () => {
      expect(AdminDashboard.props).toEqual({
        chartEndpoints: {
          type: Object,
          default: expect.any(Function),
        },

        totals: {
          type: Object,
          default: expect.any(Function),
        },
      })
    })

    describe('chartEndpoints', () => {

      it('returns an empty object by default', () => {
        expect(AdminDashboard.props.chartEndpoints.default()).toEqual({})
      })

    })

    describe('totals', () => {

      it('returns an empty object by default', () => {
        expect(AdminDashboard.props.totals.default()).toEqual({})
      })

    })

  })

  describe('created', () => {

    it('commits the chartEndpoints prop data to the store', () => {
      const commitSpy = spyOn(store, 'commit')

      expect(commitSpy).not.toHaveBeenCalled()

      wrapper = shallowMount(
        AdminDashboard, {
          localVue,
          router,
          store,
          propsData: {
            chartEndpoints,
            totals,
          }
        }
      )

      expect(commitSpy).toHaveBeenCalledWith(
        'addChartEndpoints',
        wrapper.vm.chartEndpoints
      )
    })

    it('commits the totals prop data to the store', () => {
      const commitSpy = spyOn(store, 'commit')

      expect(commitSpy).not.toHaveBeenCalled()

      wrapper = shallowMount(
        AdminDashboard, {
          localVue,
          router,
          store,
          propsData: {
            chartEndpoints,
            totals,
          }
        }
      )

      expect(commitSpy).toHaveBeenCalledWith(
        'addTotals',
        wrapper.vm.totals
      )
    })

  })

})