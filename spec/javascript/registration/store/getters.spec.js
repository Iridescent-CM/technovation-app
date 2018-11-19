import getters from 'registration/store/getters'

describe("student/store/getters.js", () => {
  describe("getBirthdate", () => {
    it ("returns correct yyyy-mm-dd string if month is not an object", () => {
      const state = {
        birthYear: '2019',
        birthMonth: '03',
        birthDay: '09',
      }

      expect(getters.getBirthdate(state)).toEqual('2019-03-09')
    })

    it ("returns correct yyyy-mm-dd string if month is an object", () => {
      const state = {
        birthYear: '2019',
        birthMonth: {
          label: '03 - March',
          value: '03',
        },
        birthDay: '09',
      }

      expect(getters.getBirthdate(state)).toEqual('2019-03-09')
    })
  })
})