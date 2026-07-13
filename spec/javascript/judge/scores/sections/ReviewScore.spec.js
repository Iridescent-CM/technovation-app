import Vue from "vue";
import Vuex from "vuex";
import VueRouter from "vue-router";
import { describe, expect, it, vi, beforeEach } from "vitest";
import { mount } from "@vue/test-utils";

import ReviewScore from "@appjs/judge/scores/sections/ReviewScore.vue";
import Swal from "sweetalert2";
import {
  buildCompleteJuniorScoreState,
  buildJudgeScoreState,
  buildJudgeScoreStore,
} from "../../../support/judgeScoreStore";
import * as getters from "@appjs/judge/scores/store/getters";
import * as mutations from "@appjs/judge/scores/store/mutations";

Vue.use(Vuex);
Vue.use(VueRouter);

function mountReviewScore(stateOverrides = {}) {
  const router = new VueRouter({
    routes: [{ name: "review-score", path: "/review" }],
  });

  const store = buildJudgeScoreStore(stateOverrides);

  const wrapper = mount(ReviewScore, {
    store,
    router,
    stubs: {
      EnergeticContainer: {
        template: "<div><slot /></div>",
      },
      TeamInfo: { template: "<div class='team-info-stub' />" },
      ThickRule: true,
      SectionProgressIcons: true,
    },
    directives: {
      tooltip: {},
    },
  });

  return { wrapper, store };
}

describe("ReviewScore", () => {
  beforeEach(() => {
    vi.spyOn(Swal, "fire").mockResolvedValue({ isConfirmed: false });
  });

  it("lists scoring sections with point totals and aggregate score", () => {
    const state = buildCompleteJuniorScoreState();
    const { wrapper } = mountReviewScore(state);

    expect(wrapper.text()).toContain("Project Description");
    expect(wrapper.text()).toContain("Pitch");
    expect(wrapper.text()).toContain("Total Score");
    expect(wrapper.text()).toContain("20");
  });

  it("disables finish score when sections are incomplete", () => {
    const incompleteState = buildJudgeScoreState({
      questions: [
        { section: "pitch", idx: 0, score: 0, worth: 5, text: "Unanswered" },
      ],
    });
    const { wrapper } = mountReviewScore(incompleteState);

    const finishLink = wrapper.find("a.link-button-success");
    expect(finishLink.text()).toBe("Finish Score");
    expect(finishLink.classes()).toContain("pointer-events-none");
  });

  it("enables finish score when every section is complete", () => {
    const { wrapper } = mountReviewScore(buildCompleteJuniorScoreState());

    const finishLink = wrapper.find("a.link-button-success");
    expect(finishLink.classes()).not.toContain("pointer-events-none");
    expect(finishLink.attributes("href")).toBe("/judge/score_completions?id=42");
  });

  it("shows update score label for completed scores", () => {
    const completeState = buildCompleteJuniorScoreState();
    completeState.score.complete = true;

    const store = new Vuex.Store({
      state: completeState,
      getters,
      mutations,
    });

    const wrapper = mount(ReviewScore, {
      store,
      router: new VueRouter({
        routes: [{ name: "review-score", path: "/review" }],
      }),
      stubs: {
        EnergeticContainer: { template: "<div><slot /></div>" },
        TeamInfo: true,
        ThickRule: true,
        SectionProgressIcons: true,
      },
      directives: { tooltip: {} },
    });

    expect(wrapper.find("a.link-button-success").text()).toBe("Update Score");
  });
});
