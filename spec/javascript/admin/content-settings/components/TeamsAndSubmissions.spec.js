import { shallowMount } from '@vue/test-utils'

import TeamsAndSubmissions from 'admin/content-settings/components/TeamsAndSubmissions'

describe('Admin Content & Settings - TeamsAndSubmissions component', () => {

  let wrapper

  beforeEach(() => {
    wrapper = shallowMount(TeamsAndSubmissions)
  })

  it('has a name attribute', () => {
    expect(TeamsAndSubmissions.name).toEqual('teams-and-submissions-section')
  })

})