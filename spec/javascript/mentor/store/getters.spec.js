import cloneDeep from 'lodash/cloneDeep'
import getters from 'mentor/store/getters'

describe("mentor/store/getters.js", () => {
  describe('getAge', () => {
    const today = new Date()

    const initialState = {
      currentAccount: {
        data: {
          attributes: {
            birthYear: today.getFullYear() - 18,
            birthMonth: today.getMonth(),
            birthDay: today.getDate(),
          },
        },
      },
    }

    let mockState

    beforeEach(() => {
      mockState = cloneDeep(initialState)
    })

    it('returns false if currentAccount.birthYear is not present', () => {
      delete mockState.currentAccount.data.attributes.birthYear

      const getAge = getters.getAge(mockState)

      expect(getAge()).toBe(false)
    })

    it('returns false if currentAccount.birthMonth is not present', () => {
      delete mockState.currentAccount.data.attributes.birthMonth

      const getAge = getters.getAge(mockState)

      expect(getAge()).toBe(false)
    })

    it('returns false if currentAccount.birthDay is not present', () => {
      delete mockState.currentAccount.data.attributes.birthDay

      const getAge = getters.getAge(mockState)

      expect(getAge()).toBe(false)
    })

    it('returns numeric age if year, month, and day are present', () => {
      expect(getters.getAge(mockState).call()).toEqual(18)
    })

    it('returns numeric age based on compareDate passed in', () => {
      const twoYearsAgo = new Date(
        today.getFullYear() - 2,
        today.getMonth(),
        today.getDay()
      )

      const getAge = getters.getAge(mockState)

      expect(getAge(twoYearsAgo)).toEqual(16)
    })
  })

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
      }

      expect(getters.isBackgroundCheckWaived(state)).toBe(true)
    })

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
      }

      expect(getters.isBackgroundCheckWaived(state)).toBe(false)
    })

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
      }

      expect(getters.isBackgroundCheckWaived(state)).toBe(true)
    })
  })

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