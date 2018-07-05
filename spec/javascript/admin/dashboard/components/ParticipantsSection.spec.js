import Vuex from 'vuex'
import { shallowMount, createLocalVue } from '@vue/test-utils'

import mockStore from 'admin/dashboard/store/__mocks__'

import DashboardSection from 'admin/dashboard/components/DashboardSection'
import ParticipantsSection from 'admin/dashboard/components/ParticipantsSection'

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

    // TODO - This test will change as we implement the actual bar chart
    it('contains the correct markup', () => {
      expect(wrapper.element.getAttribute('id')).toEqual('participants')
      expect(wrapper.find('h3').html())
        .toEqual('<h3>Participants</h3>')

      expect(wrapper.find('.tab-content').text())
        .toEqual('[[ BAR CHART GOES HERE ]]')
    })

  })

})