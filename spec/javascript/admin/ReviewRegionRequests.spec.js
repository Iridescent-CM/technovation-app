import { shallowMount, createLocalVue } from '@vue/test-utils'
import axios from 'axios'

import Vuex from 'vuex'
import VTooltip from 'v-tooltip'
import Vue2Filters from 'vue2-filters'

import ReviewRegionRequests from 'admin/review-requests/components/ReviewRegionRequests'
import Request from 'admin/review-requests/models/request'

const localVue = createLocalVue()

localVue.use(Vuex)
localVue.use(VTooltip)
localVue.use(Vue2Filters)

describe('List pending requests', () => {
  beforeEach(() => {
    axios.get.mockClear()
    axios.patch.mockClear()
  })

  it('starts out loading', () => {
    const wrapper = shallowMount(
      ReviewRegionRequests, {
        localVue,
        propsData: {
          sourceUrl: '/some/url',
        },
      }
    )

    expect(wrapper.find('.loading').text()).toEqual('Loading...')
  })

  describe('#approveRequest()', () => {
    it('patches request_status => approved to the request patch URL', (done) => {
      const wrapper = shallowMount(
        ReviewRegionRequests, {
          localVue,
          propsData: {
            sourceUrl: '/some/url',
          },
        }
      )

      const axiosPatchSpy = jest.spyOn(axios, 'patch')

      wrapper.vm.approveRequest(new Request({
        id: 1,
        attributes: { urls: { patch: '/endpoint/1' } }
      }))

      setImmediate(() => {
        expect(axiosPatchSpy).toHaveBeenLastCalledWith('/endpoint/1', {
          request_status: "approved"
        })

        done()
      })
    })
  })

  describe('#declineRequest()', () => {
    it('patches request_status => declined to the request patch URL', (done) => {
      const wrapper = shallowMount(
        ReviewRegionRequests, {
          localVue,
          propsData: {
            sourceUrl: '/some/url',
          },
        }
      )

      const axiosPatchSpy = jest.spyOn(axios, 'patch')

      wrapper.vm.declineRequest(new Request({
        id: 1,
        attributes: { urls: { patch: '/endpoint/1' } }
      }))

      setImmediate(() => {
        expect(axiosPatchSpy).toHaveBeenLastCalledWith('/endpoint/1', {
          request_status: "declined"
        })

        done()
      })
    })
  })

  describe('#loadData()', () => {
    it('assigns requests from remote data', (done) => {
      axios.mockResponseOnce("get", { data: [
        {
          id: "1",
          type: "request",
          attributes: {
            requestor_avatar: "https://placekitten.com/g/233/233",
            requestor_name: "RA Ambassador",
            requestor_meta: {
              regions: [
                "Ontario, CA",
                "California, US",
                "MX"
              ]
            },
            requestor_message: "I want to add these regions because...",
            request_type: "AMBASSADOR_ADD_REGION",
            request_status: "pending",
            urls: {
              patch: "http://localhost:3000/admin/requests/1"
            }
          }
        },
        {
          id: "2",
          type: "request",
          attributes: {
            requestor_avatar: "https://placekitten.com/g/250/250",
            requestor_name: "Other Ambassador",
            requestor_meta: {
              regions: [
                "Maine, US",
                "New York, US"
              ]
            },
            requestor_message: "I want to add these OTHER regions because...",
            request_type: "AMBASSADOR_ADD_REGION",
            request_status: "pending",
            urls: {
              patch: "http://localhost:3000/admin/requests/1"
            }
          }
        }
      ]})

      const wrapper = shallowMount(
        ReviewRegionRequests, {
          localVue,
          propsData: {
            sourceUrl: '/some/url',
          },
        }
      )

      setImmediate(() => {
        expect(wrapper.vm.requests.length).toBe(2)
        expect(wrapper.vm.isLoading).toBe(false)
        expect(wrapper.vm.requests[1].requestor_meta.regions).toEqual([
          "Maine, US", "New York, US"
        ])
        done()
      })
    })
  })
})