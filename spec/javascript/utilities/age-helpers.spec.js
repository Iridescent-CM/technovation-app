import { describe, expect, it, vi, beforeEach, afterEach } from "vitest";

import {
  calculateAgeByDivisionCutoffDate,
  verifyOlderThanEighteen,
  verifyStudentAge,
} from "@appjs/utilities/age-helpers";

describe("age-helpers", () => {
  beforeEach(() => {
    vi.useFakeTimers();
    vi.setSystemTime(new Date("2026-06-01T12:00:00Z"));
  });

  afterEach(() => {
    vi.useRealTimers();
  });

  describe("calculateAgeByDivisionCutoffDate", () => {
    it("returns age at the division cutoff date", () => {
      expect(
        calculateAgeByDivisionCutoffDate({ birthday: "2014-08-02" })
      ).toBe(11);
    });
  });

  describe("verifyStudentAge", () => {
    it("accepts beginner division ages 8-12 at cutoff", () => {
      expect(
        verifyStudentAge({ birthday: "2014-08-02", division: "beginner" })
      ).toBe(true);
      expect(
        verifyStudentAge({ birthday: "2018-08-01", division: "beginner" })
      ).toBe(true);
    });

    it("rejects beginner division ages outside 8-12", () => {
      expect(
        verifyStudentAge({ birthday: "2019-08-02", division: "beginner" })
      ).toBe(false);
      expect(
        verifyStudentAge({ birthday: "2007-08-02", division: "beginner" })
      ).toBe(false);
    });

    it("accepts junior/senior division ages 13-18 at cutoff", () => {
      expect(
        verifyStudentAge({ birthday: "2008-08-02", division: "junior" })
      ).toBe(true);
      expect(
        verifyStudentAge({ birthday: "2013-08-01", division: "senior" })
      ).toBe(true);
    });

    it("rejects junior/senior division ages outside 13-18", () => {
      expect(
        verifyStudentAge({ birthday: "2014-08-02", division: "junior" })
      ).toBe(false);
      expect(
        verifyStudentAge({ birthday: "2006-07-31", division: "senior" })
      ).toBe(false);
    });
  });

  describe("verifyOlderThanEighteen", () => {
    it("returns true when birthday is 18 or older today", () => {
      expect(verifyOlderThanEighteen({ birthday: "2000-01-01" })).toBe(true);
    });

    it("returns false when birthday is under 18 today", () => {
      expect(verifyOlderThanEighteen({ birthday: "2015-01-01" })).toBe(false);
    });
  });
});
