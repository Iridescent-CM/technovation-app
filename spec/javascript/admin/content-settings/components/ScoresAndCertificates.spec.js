import Vuex from 'vuex'
import { shallowMount, createLocalVue } from '@vue/test-utils'

import mockStore from 'admin/content-settings/store/__mocks__'
import ScoresAndCertificates from 'admin/content-settings/components/ScoresAndCertificates'

const localVue = createLocalVue()
localVue.use(Vuex)

describe('Admin Content & Settings - ScoresAndCertificates component', () => {

  let wrapper

  beforeEach(() => {
    wrapper = shallowMount(
      ScoresAndCertificates,
      {
        localVue,
        store: mockStore.createMocks().store,
      }
    )
  })

  it('has a name attribute', () => {
    expect(ScoresAndCertificates.name).toEqual('scores-and-certificates-section')
  })

})