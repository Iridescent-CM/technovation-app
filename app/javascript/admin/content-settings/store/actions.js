import axios from 'axios' // temporarily bypassing the whole axios case converter stuff
export default {
  init({ commit, state}) {
    return new Promise((resolve, reject) => {
      axios.get('/admin/season_schedule_settings.json')
        .then(({ data }) => {
          if (data.data) {
            commit('setFormData', data.data.attributes)
            resolve()
          } else {
            reject()
          }
        }).catch(err => reject(err))
    })
  }
}