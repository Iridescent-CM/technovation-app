import merge from 'lodash/merge'
import 'axios'
import { shallowMount, createLocalVue } from '@vue/test-utils'
import Vuex from 'vuex'

import mockStore from 'registration/store/__mocks__'
import ChooseProfile from 'registration/components/ChooseProfile'

const localVue = createLocalVue()
localVue.use(Vuex)

describe("Registration::Components::ChooseProfile.vue", () => {
  const propsData = {
    profileIcons: {
      profileIconMentor: 'mentor.svg',
      profileIconMentorMale: 'male_mentor.svg',
      profileIconStudent: 'student.svg',
    },
  }

  let defaultWrapper

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
        propsData,
      }
    )
  })

  describe('computed properties', () => {
    describe('profileOptions', () => {
      function createWrapperWithAge (getAgeReturnValue = null, getAgeByCutoffReturnValue = null) {
        const defaultStore = createMockStore({
          getters: {
            getAge () {
              return () => {
                return getAgeReturnValue
              }
            },
            getAgeByCutoff () {
              return getAgeByCutoffReturnValue || getAgeReturnValue
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
            propsData,
          }
        )
      }

      it('returns an empty array and sets profile choice to null if cannot calculate age', () => {
        const wrapper = createWrapperWithAge(null)

        expect(wrapper.vm.getAge()).toEqual(null)
        expect(wrapper.vm.getAgeByCutoff).toEqual(null)
        expect(wrapper.vm.profileOptions).toEqual([])
        expect(wrapper.vm.profileChoice).toEqual(null)
      })

      it('returns an empty array and sets profile choice to null if age by cutoff < 10', () => {
        const wrapper = createWrapperWithAge(9)

        expect(wrapper.vm.getAge()).toEqual(9)
        expect(wrapper.vm.getAgeByCutoff).toEqual(9)
        expect(wrapper.vm.profileOptions).toEqual([])
        expect(wrapper.vm.profileChoice).toEqual(null)
      })

      it('returns student and sets profile choice to student if age is 9 but age by cutoff is 10', () => {
        const wrapper = createWrapperWithAge(9, 10)

        expect(wrapper.vm.getAge()).toEqual(9)
        expect(wrapper.vm.getAgeByCutoff).toEqual(10)
        expect(wrapper.vm.profileOptions).toEqual(['student'])
        expect(wrapper.vm.profileChoice).toEqual('student')
      })

      it('returns student and sets profile choice to student if age < 18', () => {
        const wrapper = createWrapperWithAge(16)

        expect(wrapper.vm.getAge()).toEqual(16)
        expect(wrapper.vm.getAgeByCutoff).toEqual(16)
        expect(wrapper.vm.profileOptions).toEqual(['student'])
        expect(wrapper.vm.profileChoice).toEqual('student')
      })

      it('returns mentor and student if age is 18 but not greater than 18 by cutoff', () => {
        const wrapper = createWrapperWithAge(18)

        expect(wrapper.vm.getAge()).toEqual(18)
        expect(wrapper.vm.getAgeByCutoff).toEqual(18)
        expect(wrapper.vm.profileOptions).toEqual(['mentor', 'student'])
      })

      it('returns mentor and sets profile choice to mentor if age by cutoff > 18', () => {
        let wrapper = createWrapperWithAge(18, 19)

        expect(wrapper.vm.getAge()).toEqual(18)
        expect(wrapper.vm.getAgeByCutoff).toEqual(19)
        expect(wrapper.vm.profileOptions).toEqual(['mentor'])
        expect(wrapper.vm.profileChoice).toEqual('mentor')

        wrapper = createWrapperWithAge(19)

        expect(wrapper.vm.getAge()).toEqual(19)
        expect(wrapper.vm.getAgeByCutoff).toEqual(19)
        expect(wrapper.vm.profileOptions).toEqual(['mentor'])
        expect(wrapper.vm.profileChoice).toEqual('mentor')
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
})
