import { describe, expect, it, vi } from "vitest";

import { validateScore } from "@appjs/judge/scores/store/actions";
import { setProblemSections } from "@appjs/judge/scores/store/mutations";

function buildState(overrides = {}) {
  return {
    problemSections: [],
    judge: { recusal_scores_count: 0 },
    score: {
      id: 1,
      comments: {
        project_details: { text: "", word_count: 25 },
        ideation: { text: "", word_count: 25 },
        entrepreneurship: { text: "", word_count: 5 },
        pitch: { text: "", word_count: 25 },
        demo: { text: "", word_count: 25 },
      },
    },
    questions: [
      { section: "pitch", score: 0, idx: 0 },
      { section: "demo", score: 4, idx: 0 },
    ],
    team: { division: "junior" },
    ...overrides,
  };
}

describe("validateScore action", () => {
  it("flags unanswered questions and short comments", () => {
    const state = buildState();
    const commit = vi.fn();

    validateScore({ commit, state });

    expect(commit).toHaveBeenCalledWith("setProblemSections", [
      "pitch",
      "entrepreneurship",
    ]);
  });

  it("skips entrepreneurship comment check for beginner division", () => {
    const state = buildState({
      team: { division: "beginner" },
      questions: [{ section: "pitch", score: 3, idx: 0 }],
      score: {
        id: 1,
        comments: {
          project_details: { text: "", word_count: 25 },
          ideation: { text: "", word_count: 25 },
          entrepreneurship: { text: "", word_count: 5 },
          pitch: { text: "", word_count: 25 },
          demo: { text: "", word_count: 25 },
        },
      },
    });
    const commit = vi.fn();

    validateScore({ commit, state });

    expect(commit).toHaveBeenCalledWith("setProblemSections", []);
  });
});

describe("setProblemSections mutation", () => {
  it("stores problem section names on state", () => {
    const state = { problemSections: [] };

    setProblemSections(state, ["pitch", "demo"]);

    expect(state.problemSections).toEqual(["pitch", "demo"]);
  });
});
