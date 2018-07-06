import Vuex from 'vuex'
import { shallowMount, createLocalVue } from '@vue/test-utils'

import mockStore from 'admin/dashboard/store/__mocks__'

import DashboardSection from 'admin/dashboard/components/DashboardSection'
import ParticipantsSection from 'admin/dashboard/components/ParticipantsSection'
import BarChart from 'components/BarChart'

const localVue = createLocalVue()

localVue.use(Vuex)

describe('Admin Dashboard - ParticipantsSection component', () => {

  let wrapper

  beforeEach(() => {
    const storeMocks = mockStore.createMocks()

    wrapper = shallowMount(
      ParticipantsSection, {
        localVue,
        store: storeMocks.store,
      }
    )
  })

  it('has a name attribute', () => {
    expect(ParticipantsSection.name).toEqual('participants-section')
  })

  it('extends the DashboardSection component', () => {
    expect(ParticipantsSection.extends).toEqual(DashboardSection)
  })

  describe('HTML markup', () => {

    it('contains the correct markup', () => {
      expect(wrapper.element.getAttribute('id')).toEqual('participants')
      expect(wrapper.find('h3').html())
        .toEqual('<h3>Participants</h3>')
      expect(wrapper.find(BarChart).exists()).toBe(true)
    })

  })

})