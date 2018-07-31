import Vuex from 'vuex'
import { shallowMount, createLocalVue } from '@vue/test-utils'

import mockStore from 'admin/content-settings/store/__mocks__'
import Review from 'admin/content-settings/components/Review'

const localVue = createLocalVue()
localVue.use(Vuex)

describe('Admin Content & Settings - Events component', () => {

  let wrapper

  beforeEach(() => {
    wrapper = shallowMount(
      Review,
      {
        localVue,
        store: mockStore.createMocks().store,
      }
    )
  })

  it('has a name attribute', () => {
    expect(Review.name).toEqual('review-and-save-settings-section')
  })

})