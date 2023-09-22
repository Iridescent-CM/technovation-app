import getters from "mentor/store/getters";

const backgroundCheckCountryCodes = "IN, CA, US";

describe("mentor/store/getters.js", () => {
  describe("isBackgroundCheckWaived", () => {
    it("is true when currentAccount.countryCode is not US", () => {
      const state = {
        currentAccount: {
          data: {
            attributes: {
              countryCode: "BR",
              age: 18,
            },
          },
        },
        settings: {
          backgroundCheckCountryCodes: backgroundCheckCountryCodes,
        },
      };

      expect(getters.isBackgroundCheckWaived(state)).toBe(true);
    });

    it("is false when currentAccount.countryCode is US", () => {
      const state = {
        currentAccount: {
          data: {
            attributes: {
              countryCode: "US",
              age: 18,
            },
          },
        },
        settings: {
          backgroundCheckCountryCodes: backgroundCheckCountryCodes,
        },
      };

      expect(getters.isBackgroundCheckWaived(state)).toBe(false);
    });

    it("is true when currentAccount.age is under 18", () => {
      const state = {
        currentAccount: {
          data: {
            attributes: {
              countryCode: "US",
              age: "17",
            },
          },
        },
        settings: {
          backgroundCheckCountryCodes: backgroundCheckCountryCodes,
        },
      };

      expect(getters.isBackgroundCheckWaived(state)).toBe(true);
    });
  });

  describe("isOnTeam", () => {
    it("is true if the mentor has a team in currentTeams", () => {
      const state = {
        currentTeams: [
          {
            data: {
              id: "db123",
            },
          },
        ],
      };

      expect(getters.isOnTeam(state)).toBeTruthy();
    });

    it("is false if the mentor has no teams in currentTeams", () => {
      const state = {
        currentTeams: [],
      };

      expect(getters.isOnTeam(state)).toBeFalsy();
    });
  });

  describe("canJoinTeams", () => {
    it("is true if the currentMentor isOnboarded", () => {
      const state = {
        currentMentor: {
          data: {
            attributes: {
              isOnboarded: true,
            },
          },
        },
      };

      expect(getters.canJoinTeams(state)).toBeTruthy();
    });
  });

  describe("isOnboarded", () => {
    it("is true if the currentMentor isOnboarded", () => {
      const state = {
        currentMentor: {
          data: {
            attributes: {
              isOnboarded: true,
            },
          },
        },
      };

      expect(getters.isOnboarded(state)).toBeTruthy();
    });
  });

  describe("canDisplayScores", () => {
    it("returns true when the display_scores setting is enabled", () => {
      const state = { settings: { canDisplayScores: true } };

      expect(getters.canDisplayScores(state)).toBe(true);
    });

    it("returns false when the display_scores setting is disabled", () => {
      const state = { settings: { canDisplayScores: false } };

      expect(getters.canDisplayScores(state)).toBe(false);
    });
  });
});
