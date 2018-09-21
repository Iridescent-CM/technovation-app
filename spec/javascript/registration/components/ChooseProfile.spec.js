import merge from 'lodash/merge'
import 'axios'
import { shallowMount, createLocalVue } from '@vue/test-utils'
import Vuex from 'vuex'

import mockStore from 'registration/store/__mocks__'
import ChooseProfile from 'registration/components/ChooseProfile'

const localVue = createLocalVue()
localVue.use(Vuex)

describe("Registration::Components::ChooseProfile.vue", () => {
  let defaultWrapper
  let settingsDiv // This is an anti-pattern. We need to refactor these into props.

  function createMockStore (options = {}) {
    const mergedOptions = merge(
      {},
      {
        actions: {
          updateProfileChoice ({ commit }, choice) {
            commit('profileChoice', choice)
          },
        },
      },
      options
    )

    return mockStore.createMocks(mergedOptions)
  }

  beforeAll(() => {
    settingsDiv = document.createElement('div')
    settingsDiv.id = 'vue-data-registration'
    settingsDiv.dataset.profileIconMentor = 'mentor.svg'
    settingsDiv.dataset.profileIconMentorMale = 'male_mentor.svg'
    settingsDiv.dataset.profileIconStudent = 'student.svg'
    document.body.appendChild(settingsDiv)
  })

  afterAll(() => {
    settingsDiv.remove()
  })

  beforeEach(() => {
    const defaultStore = createMockStore()

    defaultWrapper = shallowMount(
      ChooseProfile,
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
          },
        }),
      }
    )
  })

  describe('computed properties', () => {
    describe('profileOptions', () => {
      function createWrapperWithAge (getAgeReturnValue = null) {
        const defaultStore = createMockStore({
          getters: {
            getAge () {
              return () => {
                return getAgeReturnValue
              }
            },
          },
        })

        return shallowMount(
          ChooseProfile,
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
              },
            }),
          }
        )
      }

      it('returns an empty array if default or cannot calculate age', () => {
        const wrapper = createWrapperWithAge(null)
        expect(wrapper.vm.profileOptions).toEqual([])
      })

      it('returns student and sets profile choice to student if age < 14', () => {
        const wrapper = createWrapperWithAge(13)

        expect(wrapper.vm.getAge()).toEqual(13)
        expect(wrapper.vm.profileOptions).toEqual(['student'])
        expect(wrapper.vm.profileChoice).toEqual('student')
      })

      it('returns mentor and sets profile choice to mentor if age by cutoff > 18', () => {
        const wrapper = createWrapperWithAge(19)

        expect(wrapper.vm.getAge()).toEqual(19)
        expect(wrapper.vm.profileOptions).toEqual(['mentor'])
        expect(wrapper.vm.profileChoice).toEqual('mentor')
      })

      it('returns mentor and student if age >= 14 and < 19; sets profile choice to student', () => {
        const wrapper = createWrapperWithAge(16)

        expect(wrapper.vm.getAge()).toEqual(16)
        expect(wrapper.vm.profileOptions).toEqual(['mentor', 'student'])
        expect(wrapper.vm.profileChoice).toEqual('student')
      })
    })
  })

  describe('methods', () => {
    describe('getProfileIconSrc', () => {
      it('returns male mentor image if gender is male and choice is mentor', (done) => {
        defaultWrapper.vm.$store.state.registration.genderIdentity = 'Male'

        defaultWrapper.vm.$nextTick(() => {
          const result = defaultWrapper.vm.getProfileIconSrc('mentor')

          expect(result).toEqual('male_mentor.svg')
          done()
        })
      })

      it('returns standard mentor image if gender is not male and choice is mentor', (done) => {
        defaultWrapper.vm.$store.state.registration.genderIdentity = 'Female'

        defaultWrapper.vm.$nextTick(() => {
          const result = defaultWrapper.vm.getProfileIconSrc('mentor')

          expect(result).toEqual('mentor.svg')
          done()
        })
      })

      it('returns student image if gender is not male and choice is student', (done) => {
        defaultWrapper.vm.$store.state.registration.genderIdentity = 'Female'

        defaultWrapper.vm.$nextTick(() => {
          const result = defaultWrapper.vm.getProfileIconSrc('student')

          expect(result).toEqual('student.svg')
          done()
        })
      })

      it('returns a blank string if choice is not present/empty', (done) => {
        defaultWrapper.vm.$store.state.registration.genderIdentity = 'Female'

        defaultWrapper.vm.$nextTick(() => {
          const result = defaultWrapper.vm.getProfileIconSrc('')

          expect(result).toEqual('')
          done()
        })
      })
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