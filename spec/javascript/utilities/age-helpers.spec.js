import {
  verifyStudentAge,
  verifyMentorAge,
} from "utilities/age-helpers.js";

const currentEnv = process.env;

beforeEach(() => {
  process.env = { ...currentEnv };
  process.env.DATES_DIVISION_CUTOFF_YEAR = "2020";
  process.env.DATES_DIVISION_CUTOFF_MONTH = "1";
  process.env.DATES_DIVISION_CUTOFF_DAY = "1";
});

afterAll(() => {
  process.env = currentEnv;
});

describe("verifyStudentAge", () => {
  describe("when a student is in the beginners division", () => {
    const division = "beginner"

    describe("when a student is 8 years old", () => {
      const birthday = "2012-01-01";

      it("returns true", () => {
        expect(verifyStudentAge({ birthday, division })).toBe(true);
      });
    });

    describe("when a student is between 8 and 12 years old", () => {
      const birthday = "2010-01-01";

      it("returns true", () => {
        expect(verifyStudentAge({ birthday, division })).toBe(true);
      });
    });

    describe("when a student is 12 years old", () => {
      const birthday = "2008-01-01";

      it("returns true", () => {
        expect(verifyStudentAge({ birthday, division })).toBe(true);
      });
    });

    describe("when a student is younger than 8 years old", () => {
      const birthday = "2012-01-02";

      it("returns false", () => {
        expect(verifyStudentAge({ birthday, division })).toBe(false);
      });
    });

    describe("when a student is older than 12 years old", () => {
      const birthday = "2003-01-02";

      it("returns false", () => {
        expect(verifyStudentAge({ birthday, division })).toBe(false);
      });
    });
  })

  describe("when a student is not in the beginners division", () => {
    const division = ""

    describe("when a student is 13 years old", () => {
      const birthday = "2007-01-01";

      it("returns true", () => {
        expect(verifyStudentAge({ birthday, division })).toBe(true);
      });
    });

    describe("when a student is between 13 and 18 years old", () => {
      const birthday = "2005-01-01";

      it("returns true", () => {
        expect(verifyStudentAge({ birthday })).toBe(true);
      });
    });

    describe("when a student is 18 years old", () => {
      const birthday = "2002-01-01";

      it("returns true", () => {
        expect(verifyStudentAge({ birthday })).toBe(true);
      });
    });

    describe("when a student is younger than 13 years old", () => {
      const birthday = "2007-01-02";

      it("returns false", () => {
        expect(verifyStudentAge({ birthday })).toBe(false);
      });
    });

    describe("when a student is older than 18 years old", () => {
      const birthday = "2001-01-01";

      it("returns false", () => {
        expect(verifyStudentAge({ birthday })).toBe(false);
      });
    });
  });
});

describe("verifyMentorAge", () => {
  describe("when a mentor is older than 18", () => {
    const birthday = "2000-01-01";

    it("returns true", () => {
      expect(verifyMentorAge({ birthday })).toBe(true);
    });
  });

  describe("when a mentor is younger than 18", () => {
    const birthday = "2010-01-01";

    it("returns false", () => {
      expect(verifyMentorAge({ birthday })).toBe(false);
    });
  });
});
