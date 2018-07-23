import Vue from 'vue'
import Vuex from 'vuex'

import state from 'admin/content-settings/store/state'

Vue.use(Vuex)

describe('Admin Content & Settings - Vuex store', () => {

  let store

  beforeEach(() => {
    const getters = {}
    const mutations = {}
    const actions = {}

    store = new Vuex.Store({
      state,
      getters,
      mutations,
      actions,
    })
  })

  it('returns the initial state used by the AdminDashboard component', () => {
    expect(state).toEqual({
      season_toggles: {
        student_signup: 0,
        mentor_signup: 0,
        student_dashboard_text: '',
        mentor_dashboard_text: '',
        judge_dashboard_text: '',
        regional_ambassador_dashboard_text: '',
        student_survey_link: {
          text: '',
          url: '',
          long_desc: '',
        },
        mentor_survey_link: {
          text: '',
          url: '',
          long_desc: '',
        },
        team_building_enabled: 0,
        team_submissions_editable: 0,
        select_regional_pitch_event: 0,
        judging_round: 'off',
        display_scores: 0,
      }
    })
  })

})