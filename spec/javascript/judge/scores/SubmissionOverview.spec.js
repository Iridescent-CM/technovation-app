import Vue from "vue";
import Vuex from "vuex";
import VueRouter from "vue-router";
import { describe, expect, it } from "vitest";
import { mount } from "@vue/test-utils";

import SubmissionOverview from "@appjs/judge/scores/SubmissionOverview.vue";
import {
  buildJudgeScoreState,
  buildJudgeScoreStore,
} from "../../support/judgeScoreStore";

Vue.use(Vuex);
Vue.use(VueRouter);

function mountSubmissionOverview(stateOverrides = {}) {
  const router = new VueRouter({
    routes: [{ name: "project_details", path: "/project-details" }],
  });

  const store = buildJudgeScoreStore(stateOverrides);

  const wrapper = mount(SubmissionOverview, {
    store,
    router,
    stubs: {
      AppIcon: true,
      ThickRule: true,
      JudgeRecusalPopup: {
        template: '<a class="recusal-popup-stub"><slot /></a>',
      },
      JudgeRecusalExceededPopup: {
        template: '<a class="recusal-exceeded-stub"><slot /></a>',
      },
    },
  });

  return { wrapper, store };
}

describe("SubmissionOverview", () => {
  it("renders team and submission context for judges", () => {
    const { wrapper } = mountSubmissionOverview();

    expect(wrapper.text()).toContain("Team alpha");
    expect(wrapper.text()).toContain("Junior Division");
    expect(wrapper.text()).toContain("Mobile App");
    expect(wrapper.text()).toContain("You are reviewing a");
  });

  it("shows start score when judging has not begun", () => {
    const { wrapper } = mountSubmissionOverview({
      questions: [],
    });

    expect(wrapper.find("a.link-button-success").text()).toBe("Start Score");
  });

  it("shows next when at least one question has been scored", () => {
    const { wrapper } = mountSubmissionOverview({
      questions: [{ section: "pitch", idx: 0, score: 3, worth: 5, text: "Q" }],
    });

    expect(wrapper.find("a.link-button-success").text()).toBe("Next");
  });

  it("shows standard recusal option while judge is under the recusal limit", () => {
    const { wrapper } = mountSubmissionOverview({
      score: {
        id: 42,
        incomplete: true,
        complete: false,
        started_at: null,
        comments: buildJudgeScoreState().score.comments,
      },
      judge: { recusal_scores_count: 1 },
    });

    expect(wrapper.find(".recusal-popup-stub").exists()).toBe(true);
    expect(wrapper.find(".recusal-exceeded-stub").exists()).toBe(false);
  });

  it("shows exceeded recusal option at the maximum recusal count", () => {
    const { wrapper } = mountSubmissionOverview({
      score: {
        id: 42,
        incomplete: true,
        complete: false,
        started_at: null,
        comments: buildJudgeScoreState().score.comments,
      },
      judge: { recusal_scores_count: 3 },
    });

    expect(wrapper.find(".recusal-exceeded-stub").exists()).toBe(true);
    expect(wrapper.find(".recusal-popup-stub").exists()).toBe(false);
  });
});
