import Vue from 'vue/dist/vue.esm'
import Vuex from 'vuex'

import axios from 'axios'

import Request from '../models/request'

Vue.use(Vuex)

export default new Vuex.Store({
  state: {
    allRequests: [],
  },

  actions: {
    init ({ commit }) {
      return new Promise((resolve, reject) => {
        axios.get('/admin/requests.json')
          .then(({ data }) => {
            data.data.forEach((request) => {
              const myRequest = new Request(request)
              commit('addRequest', myRequest)
            })

            resolve()
          }).catch(err => reject(err))
      })
    },

    updateRequest({ commit }, { request, options }) {
      axios.patch(
        request.urls.patch,
        options.attributes,
      ).then(({ data }) => {
        const req = new Request(data.data)

        if (req[options.verify]()) {
          commit('replaceRequest', req)
          swal(options.confirmMsg)
        } else {
          console.error(req, req[options.verify]())
          swal('Error. Please tell the dev team.')
        }
      }).catch((err) => {
        console.error(err)
        swal('Error. Please tell the dev team.')
      })
    },
  },

  mutations: {
    addRequest (state, request) {
      const idx = state.allRequests.findIndex(r => r.id === request.id)
      if (idx === -1) {
        state.allRequests.push(request)
      } else {
        return false
      }
    },

    replaceRequest (state, request) {
      const idx = state.allRequests.findIndex(r => r.id === request.id)
      state.allRequests.splice(idx, 1, request)
    },
  },
})