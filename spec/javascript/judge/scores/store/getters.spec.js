import { describe, expect, it } from "vitest";

import * as getters from "@appjs/judge/scores/store/getters";

function buildState(overrides = {}) {
  return {
    problemSections: [],
    judge: { recusal_scores_count: 0 },
    score: {
      id: 1,
      complete: false,
      started_at: null,
      comments: {
        project_details: { text: "", word_count: 0 },
        ideation: { text: "", word_count: 0 },
        entrepreneurship: { text: "", word_count: 0 },
        pitch: { text: "", word_count: 0 },
        demo: { text: "", word_count: 0 },
      },
    },
    questions: [],
    team: {
      id: 1,
      name: "Team",
      location: "NYC",
      division: "junior",
      photo: "",
    },
    submission: {
      id: 1,
      name: "App",
      description: "",
      development_platform: "",
      deadline: "",
      screenshots: [],
    },
    ...overrides,
  };
}

function buildQuestions(section, scores) {
  return scores.map((score, idx) => ({
    section,
    idx,
    score,
    worth: 5,
    field: `${section}_q${idx}`,
    text: `Question ${idx + 1}`,
  }));
}

describe("judge scores getters", () => {
  describe("totalScore and totalPossibleScore", () => {
    it("sums question scores and possible points", () => {
      const state = buildState({
        questions: [
          { section: "pitch", score: 3, worth: 5 },
          { section: "demo", score: 4, worth: 5 },
        ],
      });

      expect(getters.totalScore(state)).toBe(7);
      expect(getters.totalPossibleScore(state)).toBe(10);
    });
  });

  describe("sections", () => {
    it("includes entrepreneurship for junior division with User Adoption Plan title", () => {
      const state = buildState({ team: { division: "junior" } });
      const localGetters = {
        sectionPointsTotal: () => () => 0,
        sectionPointsPossible: () => () => 10,
        isSectionComplete: () => () => false,
      };

      const sections = getters.sections(state, localGetters);
      const entrepreneurship = sections.find(
        (section) => section.name === "entrepreneurship"
      );

      expect(entrepreneurship).toBeDefined();
      expect(entrepreneurship.title).toBe("User Adoption Plan");
    });

    it("uses Business Canvas title for senior division entrepreneurship", () => {
      const state = buildState({ team: { division: "senior" } });
      const localGetters = {
        sectionPointsTotal: () => () => 0,
        sectionPointsPossible: () => () => 10,
        isSectionComplete: () => () => false,
      };

      const sections = getters.sections(state, localGetters);
      const entrepreneurship = sections.find(
        (section) => section.name === "entrepreneurship"
      );

      expect(entrepreneurship.title).toBe("Business Canvas");
    });

    it("omits entrepreneurship for beginner division", () => {
      const state = buildState({ team: { division: "beginner" } });
      const localGetters = {
        sectionPointsTotal: () => () => 0,
        sectionPointsPossible: () => () => 10,
        isSectionComplete: () => () => false,
      };

      const sections = getters.sections(state, localGetters);

      expect(
        sections.some((section) => section.name === "entrepreneurship")
      ).toBe(false);
    });
  });

  describe("isSectionComplete", () => {
    it("requires all questions scored and comment word count between 20 and 150", () => {
      const state = buildState({
        questions: buildQuestions("pitch", [3, 4]),
        score: {
          ...buildState().score,
          comments: {
            ...buildState().score.comments,
            pitch: { text: "twenty words here ".repeat(2), word_count: 25 },
          },
        },
      });

      const localGetters = {
        sectionQuestions: getters.sectionQuestions(state),
      };

      expect(getters.isSectionComplete(state, localGetters)("pitch")).toBe(
        true
      );
    });

    it("returns false when comment is too short", () => {
      const state = buildState({
        questions: buildQuestions("pitch", [3, 4]),
        score: {
          ...buildState().score,
          comments: {
            ...buildState().score.comments,
            pitch: { text: "too short", word_count: 5 },
          },
        },
      });

      const localGetters = {
        sectionQuestions: getters.sectionQuestions(state),
      };

      expect(getters.isSectionComplete(state, localGetters)("pitch")).toBe(
        false
      );
    });

    it("returns false when a question is unanswered", () => {
      const state = buildState({
        questions: buildQuestions("pitch", [3, 0]),
        score: {
          ...buildState().score,
          comments: {
            ...buildState().score.comments,
            pitch: { text: "twenty words here ".repeat(2), word_count: 25 },
          },
        },
      });

      const localGetters = {
        sectionQuestions: getters.sectionQuestions(state),
      };

      expect(getters.isSectionComplete(state, localGetters)("pitch")).toBe(
        false
      );
    });
  });

  describe("hasIncompleteSections", () => {
    it("returns true when any section is incomplete", () => {
      const state = buildState({ team: { division: "beginner" } });
      const localGetters = {
        sections: [{ name: "pitch" }, { name: "demo" }],
        isSectionComplete: (section) => section === "pitch",
      };

      expect(getters.hasIncompleteSections(state, localGetters)).toBe(true);
    });
  });
});
