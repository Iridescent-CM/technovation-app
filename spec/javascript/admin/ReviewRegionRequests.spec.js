import { shallowMount, createLocalVue } from '@vue/test-utils'

import Vuex from 'vuex'
import VTooltip from 'v-tooltip'
import Vue2Filters from 'vue2-filters'

import ReviewRegionRequests from 'admin/review-requests/ReviewRegionRequests'

const localVue = createLocalVue()

localVue.use(Vuex)
localVue.use(VTooltip)
localVue.use(Vue2Filters)

let wrapper

describe('List pending requests', () => {
  beforeEach(() => {
    wrapper = shallowMount(
      ReviewRegionRequests, {
        localVue,
      }
    )
  })

  test('mounts', () => {
    expect(wrapper.find('div').text()).toEqual('Review region requests')
  })
})