import Vuex from 'vuex'
import { shallowMount, createLocalVue } from '@vue/test-utils'

import mockStore from 'admin/content-settings/store/__mocks__'
import Judging from 'admin/content-settings/components/Judging'

const localVue = createLocalVue()
localVue.use(Vuex)

describe('Admin Content & Settings - Judging component', () => {

  let wrapper

  beforeEach(() => {
    wrapper = shallowMount(
      Judging,
      {
        localVue,
        store: mockStore.createMocks().store,
      }
    )
  })

  it('has a name attribute', () => {
    expect(Judging.name).toEqual('judging-section')
  })

})