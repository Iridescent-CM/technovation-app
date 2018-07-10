import Request from '../models/request'

export default {
  init ({ commit, state }) {
    return new Promise((resolve, reject) => {
      window.axios.get('/admin/requests.json')
        .then(({ data }) => {
          if (data.data) {
            data.data.forEach((request) => {
              const myRequest = new Request(request)
              commit('addRequest', myRequest)
            })
            resolve()
          } else {
            reject()
          }
        }).catch(err => reject(err))
    })
  },

  updateRequest({ commit }, { request, options }) {
    return new Promise((resolve, reject) => {
      window.axios.patch(
        request.urls.patch,
        options.attributes,
      ).then(({ data }) => {
        const req = new Request(data.data)

        if (req[options.verify]()) {
          commit('replaceRequest', req)
          resolve(req)
        } else {
          console.error(req, req[options.verify]())
          reject(req)
        }
      }).catch((err) => {
        console.error(err)
        reject()
      })
    })
  },
}