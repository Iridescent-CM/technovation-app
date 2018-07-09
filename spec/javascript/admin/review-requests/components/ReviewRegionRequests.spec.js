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
          requests: [],
          requestStatus: 'pending',
        },
      }
    )
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
      const pendingRequestJSON = {
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
        },
      }

      axios.mockResponseOnce("get", { data: [pendingRequestJSON] })

      const myUpdatingWrapper = shallowMount(
        ReviewRegionRequests, {
          localVue,
          store,
          propsData: {
            requests: [new Request(pendingRequestJSON)],
            requestStatus: 'pending',
          },
          created () {
            this.$store.dispatch("init")
          },
        }
      )

      axios.mockResponseOnce("patch", {
        data: Object.assign({},
          pendingRequestJSON,
          { attributes: { request_status: "declined" } }
        ),
      })

      setImmediate(() => {
        wrapper.vm.declineRequest(myUpdatingWrapper.vm.requests[0])

        expect(axios.patch).toHaveBeenLastCalledWith(
          'http://declineme.com/admin/requests/1',
          { request_status: "declined" }
        )

        setImmediate(() => {
          const updatedRequest = myUpdatingWrapper.vm.$store.state.allRequests[0]
          expect(updatedRequest.request_status).toEqual('declined')
          done()
        })
      })
    })
  })
})