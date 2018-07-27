import Vuex from 'vuex'
import { shallowMount, createLocalVue } from '@vue/test-utils'

import mockStore from 'admin/content-settings/store/__mocks__'
import Surveys from 'admin/content-settings/components/Surveys'

const localVue = createLocalVue()
localVue.use(Vuex)

describe('Admin Content & Settings - Surveys component', () => {

  let wrapper

  beforeEach(() => {
    wrapper = shallowMount(
      Surveys,
      {
        localVue,
        store: mockStore.createMocks().store,
      }
    )
  })

  it('has a name attribute', () => {
    expect(Surveys.name).toEqual('surveys-section')
  })

})