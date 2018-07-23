import { shallowMount } from '@vue/test-utils'

import ScoresAndCertificates from 'admin/content-settings/components/ScoresAndCertificates'

describe('Admin Content & Settings - ScoresAndCertificates component', () => {

  let wrapper

  beforeEach(() => {
    wrapper = shallowMount(ScoresAndCertificates)
  })

  it('has a name attribute', () => {
    expect(ScoresAndCertificates.name).toEqual('scores-and-certificates-section')
  })

})