import { shallowMount, createLocalVue } from '@vue/test-utils'
import mockStore from 'admin/review-requests/store/__mocks__'
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
  let wrapper
  let store

  beforeAll(() => {
    console.error = jest.fn(() => {})
  })

  beforeEach(() => {
    store = mockStore.createMocks().store
    store.replaceState({ allRequests: [] })

    axios.get.mockClear()
    axios.patch.mockClear()

    wrapper = shallowMount(
      ReviewRegionRequests, {
        store,
        localVue,
        propsData: {
          sourceUrl: '/some/url',
          requestStatus: 'pending',
        },
      }
    )
  })

  it('starts out loading', () => {
    const myUncreatedWrapper = shallowMount(
      ReviewRegionRequests, {
        store,
        localVue,
        propsData: {
          sourceUrl: '/some/url',
          requestStatus: 'pending',
        },
        created () {
          // no op stub for this test
        },
      }
    )
    expect(myUncreatedWrapper.find('.loading').text()).toEqual('Loading...')
  })

  describe('#approveRequest()', () => {
    it('patches request_status => approved to the request patch URL', () => {
      const axiosPatchSpy = jest.spyOn(axios, 'patch')

      wrapper.vm.approveRequest(new Request({
        id: 1,
        attributes: { urls: { patch: '/endpoint/1' } }
      }))

      expect(axiosPatchSpy).toHaveBeenLastCalledWith('/endpoint/1', {
        request_status: "approved"
      })
    })
  })

  describe('#declineRequest()', () => {
    it('patches request_status => declined to the request patch URL', () => {
      const axiosPatchSpy = jest.spyOn(axios, 'patch')

      wrapper.vm.declineRequest(new Request({
        id: 1,
        attributes: { urls: { patch: '/endpoint/1' } }
      }))

      expect(axiosPatchSpy).toHaveBeenLastCalledWith('/endpoint/1', {
        request_status: "declined"
      })
    })

    it('updates the request from the response', (done) => {
      axios.mockResponseOnce("get", { data: [
        {
          id: "1",
          type: "request",
          attributes: {
            requestor_avatar: "https://declineme.com/",
            requestor_name: "Decline Me",
            requestor_meta: {
              regions: [
                "Decline, CA",
              ]
            },
            requestor_message: "I want to be declined",
            request_type: "AMBASSADOR_ADD_REGION",
            request_status: "pending",
            urls: {
              patch: "http://declineme.com/admin/requests/1"
            }
          }
        },
      ] })

      const myUpdatingWrapper = shallowMount(
        ReviewRegionRequests, {
          localVue,
          store,
          propsData: {
            sourceUrl: '/some/url',
            requestStatus: 'pending',
          },
        }
      )

      axios.mockResponseOnce("patch", { data: {
        id: "1",
        type: "request",
        attributes: {
          requestor_avatar: "https://declineme.com/",
          requestor_name: "Decline Me",
          requestor_meta: {
            regions: [
              "Decline, CA",
            ]
          },
          requestor_message: "I want to be declined",
          request_type: "AMBASSADOR_ADD_REGION",
          request_status: "declined",
          urls: {
            patch: "http://declineme.com/admin/requests/1"
          }
        }
      }})

      setImmediate(() => {
        wrapper.vm.declineRequest(myUpdatingWrapper.vm.requests[0])

        expect(axios.patch).toHaveBeenLastCalledWith(
          'http://declineme.com/admin/requests/1',
          { request_status: "declined" }
        )

        setImmediate(() => {
          expect(myUpdatingWrapper.vm.requests.length).toBe(0)
          expect(myUpdatingWrapper.vm.$store.state.allRequests.length).toBe(1)

          const updatedRequest = myUpdatingWrapper.vm.$store.state.allRequests[0]
          expect(updatedRequest.request_status).toEqual('declined')
          done()
        })
      })
    })
  })

  describe('#created()', () => {
    it('assigns requests from remote data', (done) => {
      axios.mockResponseOnce("get", { data: [
        {
          id: "1",
          type: "request",
          attributes: {
            requestor_avatar: "https://placekitten.com/g/100/100",
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
            requestor_avatar: "https://placekitten.com/g/200/200",
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
              patch: "http://localhost:3000/admin/requests/2"
            }
          }
        },
        {
          id: "3",
          type: "request",
          attributes: {
            requestor_avatar: "https://placekitten.com/g/300/300",
            requestor_name: "Other Ambassador",
            requestor_meta: {
              regions: [
                "Third request, US",
              ]
            },
            requestor_message: "I want to add these OTHER regions because...",
            request_type: "AMBASSADOR_ADD_REGION",
            request_status: "approved",
            urls: {
              patch: "http://localhost:3000/admin/requests/3"
            }
          }
        }
      ]})

      const myWrapper = shallowMount(
        ReviewRegionRequests, {
          localVue,
          store,
          propsData: {
            sourceUrl: '/some/url',
            requestStatus: 'pending',
          },
        }
      )

      setImmediate(() => {
        expect(myWrapper.vm.requests.length).toEqual(2)
        expect(myWrapper.vm.isLoading).toBe(false)
        expect(myWrapper.vm.requests[1].requestor_meta.regions).toEqual([
          "Maine, US", "New York, US"
        ])
        done()
      })
    })
  })
})