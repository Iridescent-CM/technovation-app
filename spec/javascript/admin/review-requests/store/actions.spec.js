import { shallowMount, createLocalVue } from '@vue/test-utils'

import actions from 'admin/review-requests/store/actions'
import Request from 'admin/review-requests/models/request'

import axios from 'axios'

describe('updateRequest', () => {
  it('updates the request in the store, from the request in the response', (done) => {
    const attributes = {
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

    const updatedRequestJSON = {
      id: "1",
      type: "request",
      attributes,
    }

    const commit = jest.fn(() => {})

    const request = new Request({
      id: 1,
      attributes: { urls: { patch: '/endpoint/2' } }
    })

    const options = {
      attributes: { request_status: "declined" },
      verify: "isDeclined",
    }

    axios.mockResponseOnce("patch", { data: updatedRequestJSON })

    actions.updateRequest({ commit }, { request, options })

    setImmediate(() => {
      expect(axios.patch).toHaveBeenLastCalledWith('/endpoint/2', {
        request_status: "declined"
      })
      expect(commit).toHaveBeenCalledWith('replaceRequest', expect.objectContaining(attributes))
      done()
    })
  })
})