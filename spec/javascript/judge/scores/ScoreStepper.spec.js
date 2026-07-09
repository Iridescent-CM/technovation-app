import Vue from "vue";
import Vuex from "vuex";
import VueRouter from "vue-router";
import { describe, expect, it } from "vitest";
import { mount } from "@vue/test-utils";

import ScoreStepper from "@appjs/judge/scores/ScoreStepper.vue";
import {
  buildCompleteJuniorScoreState,
  buildJudgeScoreStore,
} from "../../support/judgeScoreStore";

Vue.use(Vuex);
Vue.use(VueRouter);

function mountScoreStepper(routeName = "pitch") {
  const router = new VueRouter({
    routes: [
      { name: "overview", path: "/overview" },
      { name: "project_details", path: "/project-details" },
      { name: "pitch", path: "/pitch" },
      { name: "demo", path: "/demo" },
      { name: "entrepreneurship", path: "/entrepreneurship" },
      { name: "ideation", path: "/ideation" },
      { name: "review-score", path: "/review" },
    ],
  });

  router.push({ name: routeName });

  const store = buildJudgeScoreStore(buildCompleteJuniorScoreState());

  const wrapper = mount(ScoreStepper, {
    store,
    router,
  });

  return { wrapper, store, router };
}

describe("ScoreStepper", () => {
  it("renders overview, section steps, and review score in order", () => {
    const { wrapper } = mountScoreStepper();

    expect(wrapper.text()).toContain("Overview");
    expect(wrapper.text()).toContain("Review Score");
    expect(wrapper.text()).toContain("User Adoption Plan");
    expect(wrapper.text()).toContain("20/25");
    expect(wrapper.findAll("li").length).toBeGreaterThan(4);
  });

  it("highlights the active route section", async () => {
    const { wrapper } = mountScoreStepper("pitch");
    await wrapper.vm.$nextTick();

    expect(wrapper.html()).toContain("text-tg-green");
    expect(wrapper.text()).toContain("Pitch");
  });

  it("shows cumulative score totals on the review step", () => {
    const { wrapper } = mountScoreStepper("review-score");

    expect(wrapper.text()).toContain("20/25");
    expect(wrapper.text()).toContain("Review Score");
  });
});
