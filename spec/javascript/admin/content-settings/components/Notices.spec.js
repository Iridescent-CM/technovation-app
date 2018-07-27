import Vuex from 'vuex'
import { shallowMount, createLocalVue } from '@vue/test-utils'

import mockStore from 'admin/content-settings/store/__mocks__'
import Notices from 'admin/content-settings/components/Notices'

const localVue = createLocalVue()
localVue.use(Vuex)

describe('Admin Content & Settings - Notices component', () => {

  let wrapper

  beforeEach(() => {
    wrapper = shallowMount(
      Notices,
      {
        localVue,
        store: mockStore.createMocks().store,
      }
    )
  })

  it('has a name attribute', () => {
    expect(Notices.name).toEqual('notices-section')
  })

})