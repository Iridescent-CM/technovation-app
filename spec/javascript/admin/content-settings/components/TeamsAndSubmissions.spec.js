import Vuex from 'vuex'
import { shallowMount, createLocalVue } from '@vue/test-utils'

import mockStore from 'admin/content-settings/store/__mocks__'
import TeamsAndSubmissions from 'admin/content-settings/components/TeamsAndSubmissions'

const localVue = createLocalVue()
localVue.use(Vuex)

describe('Admin Content & Settings - TeamsAndSubmissions component', () => {

  let wrapper

  beforeEach(() => {
    wrapper = shallowMount(
      TeamsAndSubmissions,
      {
        localVue,
        store: mockStore.createMocks().store,
      }
    )
  })

  it('has a name attribute', () => {
    expect(TeamsAndSubmissions.name).toEqual('teams-and-submissions-section')
  })

})