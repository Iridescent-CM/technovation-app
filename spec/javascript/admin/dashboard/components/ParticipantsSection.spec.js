import Vuex from 'vuex'
import { shallowMount, createLocalVue } from '@vue/test-utils'

import state from 'admin/dashboard/store/state'
import mockStore from 'admin/dashboard/store/__mocks__'

import DashboardSection from 'admin/dashboard/components/DashboardSection'
import ParticipantsSection from 'admin/dashboard/components/ParticipantsSection'
import BarChart from 'components/BarChart'

const localVue = createLocalVue()

localVue.use(Vuex)

describe('Admin Dashboard - ParticipantsSection component', () => {

  let wrapper

  const participants = {
    totals: {
      mentors: '19,765',
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
        'participants': '/participants/endpoint',
      },
      cachedStates: {
        '/participants/endpoint': participants,
      },
    })

    const storeMocks = mockStore.createMocks({
      state: initialState,
    })

    wrapper = shallowMount(
      ParticipantsSection, {
        localVue,
        store: storeMocks.store,
      }
    )

    wrapper.vm.totals = participants.totals
  })

  it('has a name attribute', () => {
    expect(ParticipantsSection.name).toEqual('participants-section')
  })

  it('extends the DashboardSection component', () => {
    expect(ParticipantsSection.extends).toEqual(DashboardSection)
  })

  describe('computed properties', () => {

    describe('participantsEndpoint', () => {

      it('returns an AJAX endpoint for the participants chart', () => {
        expect(wrapper.vm.participantsEndpoint)
          .toEqual('/participants/endpoint')
      })

    })

    describe('participantsChartData', () => {

      it('returns the cached chart data for the participants chart', () => {
        expect(wrapper.vm.participantsChartData)
          .toEqual(participants)

        const initialState = Object.assign({}, state, {
          cachedStates: {},
        })

        const storeMocks = mockStore.createMocks({
          state: initialState,
        })

        wrapper = shallowMount(
          ParticipantsSection, {
            localVue,
            store: storeMocks.store,
          }
        )

        expect(wrapper.vm.participantsChartData)
          .toEqual({})
      })

    })

  })

  describe('HTML markup', () => {

    it('contains the correct markup', () => {
      expect(wrapper.element.getAttribute('id')).toEqual('participants')
      expect(wrapper.find('h3').html())
        .toEqual('<h3>Participants<!----></h3>')
      expect(wrapper.find(BarChart).exists()).toBe(true)
    })

  })

})