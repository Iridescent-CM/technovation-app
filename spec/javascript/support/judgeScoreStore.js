import Vuex from "vuex";

import * as getters from "@appjs/judge/scores/store/getters";
import * as mutations from "@appjs/judge/scores/store/mutations";

const emptyComment = { text: "", word_count: 0 };

function completeComment(text) {
  const words = text.split(" ");
  return { text, word_count: words.length };
}

export function buildJudgeScoreState(overrides = {}) {
  return {
    problemSections: [],
    judge: { recusal_scores_count: 0 },
    score: {
      id: 42,
      incomplete: true,
      complete: false,
      started_at: "2020-01-01T00:00:00.000Z",
      comments: {
        project_details: emptyComment,
        ideation: emptyComment,
        entrepreneurship: emptyComment,
        pitch: emptyComment,
        demo: emptyComment,
      },
    },
    questions: [],
    team: {
      id: 1,
      name: "team alpha",
      location: "chicago, illinois",
      division: "junior",
      photo: "https://example.com/photo.jpg",
    },
    submission: {
      id: 99,
      name: "Eco App",
      description: "Helps the environment",
      development_platform: "Mobile App",
    },
    deadline: "May 20, 2026",
    ...overrides,
  };
}

export function buildCompleteJuniorScoreState() {
  const longComment = completeComment(
    "one two three four five six seven eight nine ten eleven twelve thirteen fourteen fifteen sixteen seventeen eighteen nineteen twenty"
  );

  return buildJudgeScoreState({
    score: {
      id: 42,
      incomplete: false,
      complete: true,
      started_at: "2020-01-01T00:00:00.000Z",
      comments: {
        project_details: longComment,
        ideation: longComment,
        entrepreneurship: longComment,
        pitch: longComment,
        demo: longComment,
      },
    },
    questions: [
      { section: "project_details", idx: 0, score: 4, worth: 5, text: "Q1" },
      { section: "pitch", idx: 0, score: 4, worth: 5, text: "Q2" },
      { section: "demo", idx: 0, score: 4, worth: 5, text: "Q3" },
      { section: "entrepreneurship", idx: 0, score: 4, worth: 5, text: "Q4" },
      { section: "ideation", idx: 0, score: 4, worth: 5, text: "Q5" },
    ],
  });
}

export function buildJudgeScoreStore(stateOverrides = {}) {
  return new Vuex.Store({
    state: buildJudgeScoreState(stateOverrides),
    getters,
    mutations,
  });
}
