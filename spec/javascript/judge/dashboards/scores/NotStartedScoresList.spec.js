import Vue from "vue";
import Vuex from "vuex";
import { describe, expect, it } from "vitest";
import { mount } from "@vue/test-utils";

import NotStartedScoresList from "@appjs/judge/dashboards/scores/NotStartedScoresList.vue";
import { buildJudgeDashboardStore } from "../../../support/judgeDashboardStore";

Vue.use(Vuex);

describe("NotStartedScoresList", () => {
  it("lists submissions waiting to be scored with start links", () => {
    const store = buildJudgeDashboardStore({
      notStarted: [
        {
          id: 1,
          app_name: "Eco App",
          team_name: "Team Alpha",
          team_division: "junior",
          judging_format: "Online",
          submission_id: 99,
        },
      ],
    });

    const wrapper = mount(NotStartedScoresList, {
      store,
      propsData: { scoresEditable: true },
    });

    expect(wrapper.text()).toContain("Submissions to Score");
    expect(wrapper.text()).toContain("Eco App");
    expect(wrapper.find("a.link-button-success").attributes("href")).toBe(
      "/judge/scores/new?team_submission_id=99"
    );
  });

  it("builds resume links for in-progress scores", () => {
    const store = buildJudgeDashboardStore({
      notStarted: [
        {
          id: 2,
          app_name: "Health Helper",
          team_name: "Team Beta",
          team_division: "senior",
          judging_format: "Online",
          score_id: 55,
        },
      ],
    });

    const wrapper = mount(NotStartedScoresList, {
      store,
      propsData: { scoresEditable: true },
    });

    expect(wrapper.find("a.link-button-success").attributes("href")).toBe(
      "/judge/scores/new?score_id=55"
    );
  });

  it("shows virtual judge guidance when there is nothing to score", () => {
    const wrapper = mount(NotStartedScoresList, {
      store: buildJudgeDashboardStore(),
      propsData: { isLiveJudge: false },
    });

    expect(wrapper.text()).toContain(
      "To start a new score, complete any scores in progress."
    );
  });

  it("shows live judge guidance when there is nothing to score", () => {
    const wrapper = mount(NotStartedScoresList, {
      store: buildJudgeDashboardStore(),
      propsData: { isLiveJudge: true },
    });

    expect(wrapper.text()).toContain("Please contact your chapter ambassador");
  });
});
