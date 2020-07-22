import { shallowMount, createLocalVue } from '@vue/test-utils'
import mockStore from 'admin/review-requests/store/__mocks__'
import axios from 'axios'

import App from 'admin/review-requests/App'

import Vuex from 'vuex'
import VTooltip from 'v-tooltip'
import Vue2Filters from 'vue2-filters'

const localVue = createLocalVue()

localVue.use(Vuex)
localVue.use(VTooltip)
localVue.use(Vue2Filters)

describe('admin/review-requests/App.vue', () => {
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
      App, {
        store,
        localVue,
      }
    )
  })


  it('starts out loading', () => {
    const myUncreatedWrapper = shallowMount(
      App, {
        store,
        localVue,
        created () {
          // no op 'stub' for this test
        },
      }
    )

    expect(myUncreatedWrapper.find('.loading').text()).toEqual('Loading...')
  })

  describe('#created()', () => {
    it('inits requests from remote data', (done) => {
      axios.mockResponseOnce("get", { data: [
        {
          id: "1",
          type: "request",
          attributes: {
            requestor_avatar: "https://placekitten.com/g/100/100",
            requestor_name: "chapter ambassador Ambassador",
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
        App, {
          localVue,
          store,
        }
      )

      setImmediate(() => {
        expect(myWrapper.vm.allRequests.length).toEqual(3)
        expect(myWrapper.vm.isLoading).toBe(false)
        expect(myWrapper.vm.allRequests[1].requestor_meta.regions).toEqual([
          "Maine, US", "New York, US"
        ])
        done()
      })
    })
  })
})
