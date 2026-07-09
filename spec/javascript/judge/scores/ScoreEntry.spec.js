import Vue from "vue";
import Vuex from "vuex";
import { describe, expect, it, vi } from "vitest";
import { mount, createLocalVue } from "@vue/test-utils";

import ScoreEntry from "@appjs/judge/scores/ScoreEntry.vue";

Vue.use(Vuex);

function mountScoreEntry({ questions = [], team = { division: "junior" } } = {}) {
  const localVue = createLocalVue();
  localVue.use(Vuex);

  const store = new Vuex.Store({
    state: { team },
    mutations: {
      updateScores: vi.fn(),
    },
  });

  const wrapper = mount(ScoreEntry, {
    localVue,
    store,
    propsData: { questions },
    stubs: {
      AppIcon: true,
    },
    directives: {
      tooltip: {},
    },
  });

  return { wrapper, store };
}

describe("ScoreEntry", () => {
  it("shows loading state when there are no questions", () => {
    const { wrapper } = mountScoreEntry({ questions: [] });

    expect(wrapper.text()).toContain("Loading questions...");
  });

  it("renders score bubbles for each question worth value", () => {
    const { wrapper } = mountScoreEntry({
      questions: [
        {
          section: "pitch",
          idx: 0,
          worth: 3,
          score: 0,
          text: "How clear is the pitch?",
        },
      ],
    });

    expect(wrapper.findAll(".score-value")).toHaveLength(3);
    expect(wrapper.text()).toContain("How clear is the pitch?");
  });

  it("commits updateScores when a score bubble is clicked", async () => {
    const localVue = createLocalVue();
    localVue.use(Vuex);

    const store = new Vuex.Store({
      state: { team: { division: "junior" } },
      mutations: {
        updateScores: vi.fn(),
      },
    });
    const commitSpy = vi.spyOn(store, "commit");

    const wrapper = mount(ScoreEntry, {
      localVue,
      store,
      propsData: {
        questions: [
          {
            section: "pitch",
            idx: 1,
            worth: 2,
            score: 0,
            text: "Question",
          },
        ],
      },
      stubs: { AppIcon: true },
      directives: { tooltip: {} },
    });

    await wrapper.findAll(".score-value").at(1).trigger("click");

    expect(commitSpy).toHaveBeenCalledWith("updateScores", {
      section: "pitch",
      idx: 1,
      score: 2,
    });
  });
});
