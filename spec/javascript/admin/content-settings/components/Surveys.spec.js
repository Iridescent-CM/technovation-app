import { shallowMount } from '@vue/test-utils'

import Surveys from 'admin/content-settings/components/Surveys'

describe('Admin Content & Settings - Surveys component', () => {

  let wrapper

  beforeEach(() => {
    wrapper = shallowMount(Surveys)
  })

  it('has a name attribute', () => {
    expect(Surveys.name).toEqual('surveys-section')
  })

})