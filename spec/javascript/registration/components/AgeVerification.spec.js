import 'axios'
import { defaultWrapperWithVuex } from '../../__utils__/technovation-test-utils'
import AgeVerification from 'registration/components/AgeVerification'

import mockStore from 'registration/store/__mocks__'

describe("Registration::Components::AgeVerification.vue", () => {
  let defaultWrapper

  beforeEach(() => {
    defaultWrapper = defaultWrapperWithVuex(
      AgeVerification,
      mockStore,
      {
        actions: {
          updateBirthdate ({ commit }, attributes) {
            commit('birthDate',  attributes)
          },

          updateProfileChoice ({ commit }, choice) {
            commit('profileChoice', choice)
          },
        },
      }
    )
  })

  describe("computed.februaryEndDay", () => {
    it("is 29 by default", () => {
      expect(defaultWrapper.vm.februaryEndDay).toEqual(29)
    })

    it("is 28 when year is not a leap year", () => {
      defaultWrapper.vm.year = 2009
      expect(defaultWrapper.vm.februaryEndDay).toEqual(28)
    })
  })

  describe("computed.monthEndDay", () => {
    it("is 31 at init", () => {
      expect(defaultWrapper.vm.monthEndDay).toEqual(31)
    })

    it("is 31 when #month() is a long month", () => {
      [1, 3, 5, 7, 8, 10, 12].forEach(longMonth => {
        const month = defaultWrapper.vm.$store.getters.getMonthByValue(longMonth)
        defaultWrapper.vm.month = month
        expect(defaultWrapper.vm.monthEndDay).toEqual(31)
      })
    })

    it("is 30 when #month() is a non-Feb short month", () => {
      [4, 6, 9, 11].forEach(shortNonFebMonth => {
        const month = defaultWrapper.vm.$store.getters.getMonthByValue(shortNonFebMonth)
        defaultWrapper.vm.month = month
        expect(defaultWrapper.vm.monthEndDay).toEqual(30)
      })
    })

    it("is 29 when #month() is February (2)", () => {
      const month = defaultWrapper.vm.$store.getters.getMonthByValue(2)
      defaultWrapper.vm.month = month
      expect(defaultWrapper.vm.monthEndDay).toEqual(29)
    })

    it("is 28 when #month() is February (2) and #year() is not a leap year", () => {
      defaultWrapper.vm.year = 2009

      const month = defaultWrapper.vm.$store.getters.getMonthByValue(2)
      defaultWrapper.vm.month = month

      expect(defaultWrapper.vm.monthEndDay).toEqual(28)
      expect(defaultWrapper.vm.days[27]).toEqual("28")
    })
  })

  describe("computed.profileOptions", () => {
    it('is an empty array by default', () => {
      expect(defaultWrapper.vm.profileOptions).toEqual([])
    })
  })
})