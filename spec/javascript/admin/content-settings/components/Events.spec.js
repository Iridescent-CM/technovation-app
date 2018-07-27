import Vuex from 'vuex'
import { shallowMount, createLocalVue } from '@vue/test-utils'

import mockStore from 'admin/content-settings/store/__mocks__'
import Events from 'admin/content-settings/components/Events'

const localVue = createLocalVue()
localVue.use(Vuex)

describe('Admin Content & Settings - Events component', () => {

  let wrapper

  beforeEach(() => {
    wrapper = shallowMount(
      Events,
      {
        localVue,
        store: mockStore.createMocks().store,
      }
    )
  })

  it('has a name attribute', () => {
    expect(Events.name).toEqual('events-section')
  })

})