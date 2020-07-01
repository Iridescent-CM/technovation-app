import getters from 'student/store/getters'

describe("student/store/getters.js", () => {
  describe("submissionComplete", () => {
    it ("is false if the server sent a NullTeamSubmission, indicated by ID: 0", () => {
      const state = {
        currentSubmission: {
          data: {
            id: "0",
          }
        },
      }

      expect(getters.submissionComplete(state)).toBeFalsy()
    })

    it ("is false if the server sent a TeamSubmission that is not complete", () => {
      const state = {
        currentSubmission: {
          data: {
            id: "abc123",
            attributes: {
              isComplete: false,
            },
          },
        },
      }

      expect(getters.submissionComplete(state)).toBeFalsy()
    })

    it ("is true if the server sent a TeamSubmission that is complete", () => {
      const state = {
        currentSubmission: {
          data: {
            id: "d243b3e3",
            attributes: {
              isComplete: true,
            },
          },
        },
      }

      expect(getters.submissionComplete(state)).toBeTruthy()
    })
  })

  describe("isOnTeam", () => {
    it ("is false if the server sent a NullTeam, indicated by ID: 0", () => {
      const state = {
        currentTeam: {
          data: {
            id: "0",
          }
        },
      }

      expect(getters.isOnTeam(state)).toBeFalsy()
    })

    it ("is true if the server sent a team, indicated by a real ID", () => {
      const state = {
        currentTeam: {
          data: {
            id: "d243b3e3",
          }
        },
      }

      expect(getters.isOnTeam(state)).toBeTruthy()
    })
  })

  describe("canDisplayScores", () => {
    it("returns true when the display_scores setting is enabled", () => {
      const state = { settings: { canDisplayScores: true } }

      expect(getters.canDisplayScores(state)).toBe(true)
    })

    it("returns false when the display_scores setting is disabled", () => {
      const state = { settings: { canDisplayScores: false } }

      expect(getters.canDisplayScores(state)).toBe(false)
    })
  })
})
