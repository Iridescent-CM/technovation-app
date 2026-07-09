import { describe, expect, it } from "vitest";

import getters from "@appjs/registration/store/getters";

function buildState(overrides = {}) {
  return {
    termsAgreed: true,
    birthYear: "2010",
    birthMonth: { label: "01 - January", value: "1" },
    birthDay: "15",
    cutoff: new Date(2026, 7, 1),
    profileChoice: "student",
    country: "United States",
    firstName: "Ada",
    lastName: "Lovelace",
    schoolCompanyName: "Analytical School",
    jobTitle: null,
    mentorType: null,
    genderIdentity: null,
    bio: "",
    months: [
      { label: "01 - January", value: "1" },
      { label: "02 - February", value: "2" },
    ],
    ...overrides,
  };
}

function resolveRegistrationGetters(state) {
  const localGetters = {
    isAgeSet: getters.isAgeSet(state),
    isLocationSet: getters.isLocationSet(state),
    isBasicProfileSet: getters.isBasicProfileSet(state),
    getAge: getters.getAge(state),
    getAgeByCutoff: getters.getAgeByCutoff(state, {
      getAge: getters.getAge(state),
    }),
    getMonthByValue: getters.getMonthByValue(state),
    getBirthdateAttributes: getters.getBirthdateAttributes(state, {
      getMonthByValue: getters.getMonthByValue(state),
    }),
  };

  return localGetters;
}

describe("registration getters", () => {
  describe("readyForAccount", () => {
    it("returns true when all account prerequisites are met for a student", () => {
      const state = buildState();
      const localGetters = resolveRegistrationGetters(state);

      expect(getters.readyForAccount(state, localGetters)).toBe(true);
    });

    it("returns false when terms are not agreed", () => {
      const state = buildState({ termsAgreed: false });
      const localGetters = resolveRegistrationGetters(state);

      expect(getters.readyForAccount(state, localGetters)).toBe(false);
    });
  });

  describe("getAge", () => {
    it("calculates age before birthday in compare year", () => {
      const state = buildState({
        birthYear: "2010",
        birthMonth: { value: "6" },
        birthDay: "15",
      });

      expect(getters.getAge(state)(new Date(2026, 2, 1))).toBe(15);
    });

    it("calculates age on or after birthday in compare year", () => {
      const state = buildState({
        birthYear: "2010",
        birthMonth: { value: "6" },
        birthDay: "15",
      });

      expect(getters.getAge(state)(new Date(2026, 5, 15))).toBe(16);
    });

    it("returns false when birthdate parts are missing", () => {
      const state = buildState({ birthDay: null });

      expect(getters.getAge(state)()).toBe(false);
    });
  });

  describe("isBasicProfileSet", () => {
    it("requires first name, last name, and school for students", () => {
      const complete = buildState({ profileChoice: "student" });
      const incomplete = buildState({
        profileChoice: "student",
        schoolCompanyName: null,
      });

      expect(getters.isBasicProfileSet(complete)).toBe(true);
      expect(getters.isBasicProfileSet(incomplete)).toBe(false);
    });

    it("requires mentor-specific fields and a 100-character bio for mentors", () => {
      const complete = buildState({
        profileChoice: "mentor",
        jobTitle: "Engineer",
        mentorType: "Industry professional",
        genderIdentity: "Female",
        bio: "a".repeat(100),
      });
      const shortBio = buildState({
        profileChoice: "mentor",
        jobTitle: "Engineer",
        mentorType: "Industry professional",
        genderIdentity: "Female",
        bio: "too short",
      });

      expect(getters.isBasicProfileSet(complete)).toBe(true);
      expect(getters.isBasicProfileSet(shortBio)).toBe(false);
    });
  });

  describe("getMonthByValue", () => {
    it("matches month values with or without leading zeros", () => {
      const state = buildState();

      expect(getters.getMonthByValue(state)("01")).toEqual({
        label: "01 - January",
        value: "1",
      });
    });
  });
});
