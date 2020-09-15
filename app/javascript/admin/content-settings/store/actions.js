import axios from 'axios'
/* FIXME: The content-settings store speaks snake_case, and window.axios comes with
 * an axios-case-converter transformation that transforms snake_case to camelCase,
 * so we have to bypass that for now with a fresh import.
 */

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