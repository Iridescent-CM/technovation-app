import Vue from "vue";
import Vuex from "vuex";
import { describe, expect, it } from "vitest";
import { mount } from "@vue/test-utils";

import FinishedScoresList from "@appjs/judge/dashboards/scores/FinishedScoresList.vue";
import {
  buildFinishedScorePayload,
  buildJudgeDashboardStore,
} from "../../../support/judgeDashboardStore";

Vue.use(Vuex);

describe("FinishedScoresList", () => {
  it("renders finished quarterfinal scores in a table", () => {
    const store = buildJudgeDashboardStore({
      finishedQf: [
        buildFinishedScorePayload({
          id: 10,
          submission_name: "Eco App",
          team_name: "Team Alpha",
          team_division: "junior",
          event_type_display_name: "Online",
          total: 65,
          total_possible: 80,
          url: "/judge/scores/10/edit",
        }),
      ],
    });

    const wrapper = mount(FinishedScoresList, {
      store,
      propsData: { round: "quarterfinals", scoresEditable: true },
    });

    expect(wrapper.text()).toContain("Finished Scores");
    expect(wrapper.text()).toContain("Eco App");
    expect(wrapper.text()).toContain("Team Alpha");
    expect(wrapper.text()).toContain("65 / 80");
    expect(wrapper.find("a.link-button-success").text()).toBe("Review or Edit");
  });

  it("shows view-only links when scores are not editable", () => {
    const store = buildJudgeDashboardStore({
      finishedQf: [
        buildFinishedScorePayload({
          id: 11,
          submission_name: "Health Helper",
          team_name: "Team Beta",
          team_division: "senior",
          event_type_display_name: "Pitch Event",
          total: 70,
          total_possible: 80,
          url: "/judge/scores/11/edit",
        }),
      ],
    });

    const wrapper = mount(FinishedScoresList, {
      store,
      propsData: { round: "quarterfinals", scoresEditable: false },
    });

    const link = wrapper.find("a.link-button-neutral");
    expect(link.text()).toBe("View score");
    expect(link.attributes("href")).toBe("/judge/scores/11");
  });

  it("renders nothing when there are no finished scores", () => {
    const wrapper = mount(FinishedScoresList, {
      store: buildJudgeDashboardStore(),
      propsData: { round: "quarterfinals" },
    });

    expect(wrapper.find("table").exists()).toBe(false);
  });
});
