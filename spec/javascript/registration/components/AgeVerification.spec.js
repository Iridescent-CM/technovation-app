import 'axios'
import { shallowMount, createLocalVue } from '@vue/test-utils'
import Vuex from 'vuex'

import mockStore from 'registration/store/__mocks__'
import AgeVerification from 'registration/components/AgeVerification'

const localVue = createLocalVue()
localVue.use(Vuex)

describe("Registration::Components::AgeVerification.vue", () => {
  let defaultWrapper

  beforeEach(() => {
    const defaultStore = mockStore.createMocks({
      actions: {
        updateBirthdate ({ commit }, attributes) {
          commit('birthDate',  attributes)
        },
      },
    })

    defaultWrapper = shallowMount(
      AgeVerification,
      {
        localVue,
        store: new Vuex.Store({
          modules: {
            registration: {
              namespaced: true,
              state: defaultStore.state,
              getters: defaultStore.getters,
              mutations: defaultStore.mutations,
              actions: defaultStore.actions,
            },
            authenticated: {
              namespaced: true,
              state: {
                currentAccount: {},
              },
            },
          },
        })
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
        const month = defaultWrapper.vm.$store.getters['registration/getMonthByValue'](longMonth)
        defaultWrapper.vm.month = month
        expect(defaultWrapper.vm.monthEndDay).toEqual(31)
      })
    })

    it("is 30 when #month() is a non-Feb short month", () => {
      [4, 6, 9, 11].forEach(shortNonFebMonth => {
        const month = defaultWrapper.vm.$store.getters['registration/getMonthByValue'](shortNonFebMonth)
        defaultWrapper.vm.month = month
        expect(defaultWrapper.vm.monthEndDay).toEqual(30)
      })
    })

    it("is 29 when #month() is February (2)", () => {
      const month = defaultWrapper.vm.$store.getters['registration/getMonthByValue'](2)
      defaultWrapper.vm.month = month
      expect(defaultWrapper.vm.monthEndDay).toEqual(29)
    })

    it("is 28 when #month() is February (2) and #year() is not a leap year", () => {
      defaultWrapper.vm.year = 2009

      const month = defaultWrapper.vm.$store.getters['registration/getMonthByValue'](2)
      defaultWrapper.vm.month = month

      expect(defaultWrapper.vm.monthEndDay).toEqual(28)
      expect(defaultWrapper.vm.days[27]).toEqual("28")
    })
  })

  describe('markup', () => {
    it('has one button element to prevent navigation issues when submitting', () => {
      // Note: if this test is failing, you can change <button> to
      // <a class="button"> for a similar effect
      const buttons = defaultWrapper.findAll('button')

      expect(buttons.length).toEqual(1)
    })
  })
})