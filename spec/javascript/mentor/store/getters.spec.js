import getters from 'mentor/store/getters'

describe("mentor/store/getters.js", () => {
  describe("isOnTeam", () => {
    it ("is true if the mentor has a team in currentTeams", () => {
      const state = {
        currentTeams: [{
          data: {
            id: 1,
          },
        }],
      }

      expect(getters.isOnTeam(state)).toBeTruthy()
    })
  })

  describe("canJoinTeams", () => {
    it ("is true if the currentMentor isOnboarded", () => {
      const state = {
        currentMentor: {
          data: {
            attributes: {
              isOnboarded: true,
            },
          },
        },
      }

      expect(getters.canJoinTeams(state)).toBeTruthy()
    })
  })

  describe("isOnboarded", () => {
    it ("is true if the currentMentor isOnboarded", () => {
      const state = {
        currentMentor: {
          data: {
            attributes: {
              isOnboarded: true,
            },
          },
        },
      }

      expect(getters.isOnboarded(state)).toBeTruthy()
    })
  })
})