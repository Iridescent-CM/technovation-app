import Vue from "vue";
import Vuex from "vuex";
import { describe, expect, it } from "vitest";
import { mount } from "@vue/test-utils";

import TeamInfo from "@appjs/judge/scores/TeamInfo.vue";
import { buildJudgeScoreStore } from "../../support/judgeScoreStore";

Vue.use(Vuex);

describe("TeamInfo", () => {
  it("renders team identity and submission platform", () => {
    const store = buildJudgeScoreStore({
      team: {
        id: 1,
        name: "team alpha",
        location: "chicago, illinois",
        division: "junior",
        photo: "https://cdn.example.com/photo.jpg",
      },
      submission: {
        id: 99,
        name: "Eco App",
        development_platform: "Mobile App",
      },
    });

    const wrapper = mount(TeamInfo, {
      store,
      stubs: { AppIcon: true },
    });

    expect(wrapper.text()).toContain("Team alpha");
    expect(wrapper.text()).toContain("JUNIOR DIVISION");
    expect(wrapper.text()).toContain("Mobile App");
    expect(wrapper.text()).toContain("Chicago, illinois");
  });

  it("links to the division-specific judging rubric", () => {
    const store = buildJudgeScoreStore({
      team: {
        id: 1,
        name: "team beta",
        location: "paris, france",
        division: "senior",
        photo: "",
      },
    });

    const wrapper = mount(TeamInfo, {
      store,
      stubs: { AppIcon: true },
    });

    expect(wrapper.find("a.tw-link-magenta").attributes("href")).toBe(
      "https://example.com/senior"
    );
    expect(wrapper.text()).toContain("senior division judging rubric");
  });

  it("builds a resized team photo url", () => {
    const store = buildJudgeScoreStore({
      team: {
        id: 1,
        name: "team gamma",
        location: "nairobi, kenya",
        division: "beginner",
        photo: "https://cdn.example.com/team.jpg",
      },
    });

    const wrapper = mount(TeamInfo, {
      store,
      stubs: { AppIcon: true },
    });

    expect(wrapper.find("img").attributes("src")).toContain("team.jpg");
  });
});
