import getters from 'mentor/store/getters'

describe("mentor/store/getters.js", () => {
  describe("isOnTeam", () => {
    it ("is true if the mentor has a team in currentTeams", () => {
      const state = {
        currentTeams: [{
          data: {
            id: 'db123',
          },
        }],
      }

      expect(getters.isOnTeam(state)).toBeTruthy()
    })

    it ("is false if the mentor has no teams in currentTeams", () => {
      const state = {
        currentTeams: [],
      }

      expect(getters.isOnTeam(state)).toBeFalsy()
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