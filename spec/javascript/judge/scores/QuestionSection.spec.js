import Vue from "vue";
import Vuex from "vuex";
import VueRouter from "vue-router";
import { describe, expect, it, vi } from "vitest";
import { mount } from "@vue/test-utils";

import QuestionSection from "@appjs/judge/scores/QuestionSection.vue";
import * as getters from "@appjs/judge/scores/store/getters";
import * as mutations from "@appjs/judge/scores/store/mutations";

Vue.use(Vuex);
Vue.use(VueRouter);

function buildStoreState() {
  return {
    problemSections: [],
    judge: { recusal_scores_count: 0 },
    score: {
      id: 1,
      comments: {
        project_details: { text: "", word_count: 0 },
        ideation: { text: "", word_count: 0 },
        entrepreneurship: { text: "", word_count: 0 },
        pitch: {
          text: "one two three four five six seven eight nine ten eleven twelve thirteen fourteen fifteen sixteen seventeen eighteen nineteen twenty twentyone twentytwo twentythree twentyfour twentyfive",
          word_count: 25,
        },
        demo: { text: "", word_count: 0 },
      },
    },
    questions: [
      {
        section: "pitch",
        idx: 0,
        score: 4,
        worth: 5,
        text: "Pitch clarity",
      },
    ],
    team: { division: "junior" },
    submission: { id: 99, name: "Submission" },
  };
}

function mountQuestionSection(props = {}) {
  const router = new VueRouter({
    routes: [
      { name: "overview", path: "/overview" },
      { name: "demo", path: "/demo" },
      { name: "pitch", path: "/pitch" },
    ],
  });

  const store = new Vuex.Store({
    state: buildStoreState(),
    getters,
    mutations: {
      ...mutations,
      saveComment: vi.fn(),
    },
  });

  const wrapper = mount(QuestionSection, {
    store,
    router,
    propsData: {
      section: "pitch",
      prevSection: "overview",
      nextSection: "demo",
      ...props,
    },
    stubs: {
      ScoreEntry: {
        template: '<div class="score-entry-stub"><slot /></div>',
      },
    },
  });

  return { wrapper, store };
}

describe("QuestionSection", () => {
  it("renders section title with possible points", () => {
    const { wrapper } = mountQuestionSection();

    expect(wrapper.text()).toContain("Pitch (5 points)");
  });

  it("shows word count guidance and current count", async () => {
    const { wrapper } = mountQuestionSection();
    await wrapper.vm.$nextTick();

    expect(wrapper.text()).toContain("Please write between 20 and 150 words");
    expect(wrapper.vm.wordCount).toBe(25);
  });

  it("updates comment text in the store when textarea changes", async () => {
    const { wrapper, store } = mountQuestionSection();
    const textarea = wrapper.find("textarea");

    await textarea.setValue("Updated feedback for students");

    expect(store.state.score.comments.pitch.text).toBe(
      "Updated feedback for students"
    );
  });

  it("renders back and next navigation links", () => {
    const { wrapper } = mountQuestionSection();

    expect(wrapper.text()).toContain("Back");
    expect(wrapper.text()).toContain("Next");
  });
});
