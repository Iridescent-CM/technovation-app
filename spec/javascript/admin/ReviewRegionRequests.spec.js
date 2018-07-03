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

  test('starts out loading', () => {
    expect(wrapper.find('.loading').text()).toEqual('Loading...')
  })

  test('can stop loading', () => {
    wrapper.vm.loadData()
    expect(wrapper.contains('.loading')).toBe(false)
  })
})