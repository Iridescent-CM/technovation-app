import Vue from "vue";
import Vuex from "vuex";
import { describe, expect, it } from "vitest";
import { mount } from "@vue/test-utils";

import SectionProgressIcons from "@appjs/judge/scores/pieces/SectionProgressIcons.vue";
import * as getters from "@appjs/judge/scores/store/getters";
import * as mutations from "@appjs/judge/scores/store/mutations";
import { buildJudgeScoreState } from "../../../support/judgeScoreStore";

Vue.use(Vuex);

function mountSectionProgressIcons(section, stateOverrides = {}) {
  const state = buildJudgeScoreState({
    questions: [
      { section: "pitch", idx: 0, score: 4, worth: 5, text: "Q1" },
      { section: "pitch", idx: 1, score: 0, worth: 5, text: "Q2" },
    ],
    score: {
      id: 42,
      incomplete: true,
      complete: false,
      started_at: null,
      comments: {
        project_details: { text: "", word_count: 0 },
        ideation: { text: "", word_count: 0 },
        entrepreneurship: { text: "", word_count: 0 },
        pitch: { text: "too short", word_count: 2 },
        demo: { text: "", word_count: 0 },
      },
    },
    ...stateOverrides,
  });

  const store = new Vuex.Store({ state, getters, mutations });

  return mount(SectionProgressIcons, {
    store,
    propsData: { section },
  });
}

describe("SectionProgressIcons", () => {
  it("shows incomplete question and comment progress for a section", () => {
    const wrapper = mountSectionProgressIcons("pitch");

    expect(wrapper.findAll("svg.text-tg-green")).toHaveLength(1);
    expect(wrapper.findAll("svg.text-gray-300")).toHaveLength(2);
  });

  it("shows fully complete progress when questions and comment meet thresholds", () => {
    const completeComment = {
      text: "one two three four five six seven eight nine ten eleven twelve thirteen fourteen fifteen sixteen seventeen eighteen nineteen twenty",
      word_count: 20,
    };

    const wrapper = mountSectionProgressIcons("pitch", {
      questions: [
        { section: "pitch", idx: 0, score: 5, worth: 5, text: "Q1" },
        { section: "pitch", idx: 1, score: 4, worth: 5, text: "Q2" },
      ],
      score: {
        id: 42,
        incomplete: false,
        complete: false,
        started_at: null,
        comments: {
          project_details: { text: "", word_count: 0 },
          ideation: { text: "", word_count: 0 },
          entrepreneurship: { text: "", word_count: 0 },
          pitch: completeComment,
          demo: { text: "", word_count: 0 },
        },
      },
    });

    expect(wrapper.findAll("svg.text-tg-green")).toHaveLength(3);
    expect(wrapper.findAll("svg.text-gray-300")).toHaveLength(0);
  });
});
