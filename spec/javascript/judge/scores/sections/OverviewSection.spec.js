import Vue from "vue";
import Vuex from "vuex";
import { describe, expect, it } from "vitest";
import { mount } from "@vue/test-utils";

import OverviewSection from "@appjs/judge/scores/sections/OverviewSection.vue";
import { buildJudgeScoreStore } from "../../../support/judgeScoreStore";

Vue.use(Vuex);

describe("OverviewSection", () => {
  it("shows a loading state before submission data is available", () => {
    const store = buildJudgeScoreStore({
      submission: { id: null, name: "", development_platform: "" },
    });

    const wrapper = mount(OverviewSection, {
      store,
      stubs: {
        AppIcon: true,
        EnergeticContainer: { template: "<div><slot /></div>" },
        SubmissionOverview: {
          template: "<div class='submission-overview-stub' />",
        },
      },
    });

    expect(wrapper.text()).toContain("Loading the submission");
    expect(wrapper.find(".submission-overview-stub").exists()).toBe(false);
  });

  it("renders submission overview once submission data is loaded", () => {
    const store = buildJudgeScoreStore({
      submission: {
        id: 99,
        name: "Eco App",
        development_platform: "Mobile App",
      },
    });

    const wrapper = mount(OverviewSection, {
      store,
      stubs: {
        AppIcon: true,
        EnergeticContainer: { template: "<div><slot /></div>" },
        SubmissionOverview: {
          template: "<div class='submission-overview-stub'>Overview body</div>",
        },
      },
    });

    expect(wrapper.text()).not.toContain("Loading the submission");
    expect(wrapper.find(".submission-overview-stub").exists()).toBe(true);
  });
});
