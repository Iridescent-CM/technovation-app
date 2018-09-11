import getters from 'student/store/getters'

describe("student/store/getters.js", () => {
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
  })
})