import Vue from "vue";
import Vuex from "vuex";

import state from "admin/content-settings/store/state";
import getters from "admin/content-settings/store/getters";
import mutations from "admin/content-settings/store/mutations";
import actions from "admin/content-settings/store/actions";

Vue.use(Vuex);

describe("Admin Content & Settings - Vuex store", () => {
  let store;

  beforeEach(() => {
    store = new Vuex.Store({
      state,
      getters,
      mutations,
      actions,
    });
  });

  it("returns the initial state used by the AdminDashboard component", () => {
    expect(state).toEqual({
      is_super_admin: false,
      student_signup: 0,
      mentor_signup: 0,
      judge_signup: 0,
      chapter_ambassador_signup: 0,
      student_dashboard_text: "",
      mentor_dashboard_text: "",
      judge_dashboard_text: "",
      chapter_ambassador_dashboard_text: "",
      student_survey_link: {
        text: "",
        url: "",
        long_desc: "",
      },
      mentor_survey_link: {
        text: "",
        url: "",
        long_desc: "",
      },
      team_building_enabled: 0,
      team_submissions_editable: 0,
      create_regional_pitch_event: 0,
      select_regional_pitch_event: 0,
      add_teams_to_regional_pitch_event: 0,
      judging_round: "off",
      display_scores: 0,
    });
  });

  describe("getters", () => {
    describe("judgingEnabled", () => {
      it("returns false if judging is not enabled", () => {
        expect(store.state.judging_round).toEqual("off");
        expect(store.getters.judgingEnabled).toBe(false);
      });

      it("returns true if judging is enabled", () => {
        store.state.judging_round = "qf";
        expect(store.state.judging_round).toEqual("qf");
        expect(store.getters.judgingEnabled).toBe(true);
      });
    });
    describe("isSuperAdmin", () => {
      it("returns false if admin is not a super admin", () => {
        expect(store.state.is_super_admin).toBe(false);
      });
    });
  });
});
