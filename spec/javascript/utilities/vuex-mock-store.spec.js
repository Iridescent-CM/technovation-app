import VuexMockStore from 'utilities/vuex-mock-store'

describe('VuexMockStore Class', () => {

  describe('constructor', () => {

    it('normalizes overrides in constructor object parameter', () => {
      let mockStore = new VuexMockStore({
        state: 'this will become an object',
        getters: null,
        mutations: [],
        // actions is undefined
        another_prop: {},
      })

      expect(mockStore.createMocks()).toEqual(expect.objectContaining({
        state: {},
        getters: {},
        mutations: {},
        actions: {},
      }))
      expect(mockStore.createMocks().another_prop).toBeUndefined()

      mockStore = new VuexMockStore({
        state: 678,
        getters: true,
        mutations: {},
        actions: false,
      })

      expect(mockStore.createMocks()).toEqual(expect.objectContaining({
        state: {},
        getters: {},
        mutations: {},
        actions: {},
      }))
    })

    it('sets the state defaults using the constructor object parameter', () => {
      const state = {
        count: 0,
      }

      const getters = {
        getCounter (state) {
          return state.count
        },
      }

      const mutations = {
        increment (state) {
          state.count++
        }
      }

      const actions = {
        increment (context) {
          context.commit('increment')
        },
      }

      const mockStore = new VuexMockStore({
        state,
        getters,
        mutations,
        actions,
      })

      expect(mockStore.createMocks()).toEqual(expect.objectContaining({
        state,
        getters,
        mutations,
        actions,
      }))
    })

  })

  describe('createMocks', () => {

    let originalStore
    let overrides
    let mockStore
    let mock

    beforeEach(() => {
      originalStore = {
        state: {
          count: 0,
        },

        getters: {
          getCounter (state) {
            return state.count
          },
        },

        mutations: {
          increment (state) {
            state.count++
          }
        },

        actions: {
          increment (context) {
            context.commit('increment')
          },
        }
      }

      overrides = {
        getters: {
          getDoubleCounter (state) {
            return state.count * 2
          },
        },

        mutations: {
          incrementDouble (state) {
            state.count = state.count * 2
          }
        },

        actions: {
          increment (context) {
            context.commit('incrementDouble')
          },
        }
      }

      mockStore = new VuexMockStore(originalStore)

      mock = mockStore.createMocks(overrides)
    })

    it('overrides the defaults passed into the constructor based on parameters', () => {
      expect(mock).toEqual(expect.objectContaining({
        state: originalStore.state,
        getters: {
          getCounter: originalStore.getters.getCounter,
          getDoubleCounter: overrides.getters.getDoubleCounter,
        },
        mutations: {
          increment: originalStore.mutations.increment,
          incrementDouble: overrides.mutations.incrementDouble,
        },
        actions: {
          increment: overrides.actions.increment,
        },
      }))
    })

    it('creates a Vuex store on the returned object using mocked store methods', () => {
      expect(mock.store.state.count).toEqual(0)
      expect(mock.store.getters.getCounter).toEqual(0)
      expect(mock.store.getters.getDoubleCounter).toEqual(0)

      mock.store.commit('increment')

      expect(mock.store.state.count).toEqual(1)
      expect(mock.store.getters.getCounter).toEqual(1)
      expect(mock.store.getters.getDoubleCounter).toEqual(2)

      mock.store.dispatch('increment')
      mock.store.commit('incrementDouble')

      expect(mock.store.state.count).toEqual(4)
      expect(mock.store.getters.getCounter).toEqual(4)
      expect(mock.store.getters.getDoubleCounter).toEqual(8)
    })

  })

  describe('isObject', () => {

    const mockStore = new VuexMockStore()

    it('returns true if the parameter passed in is an object', () => {
      expect(mockStore.isObject({})).toBe(true)
    })

    it('returns false if the parameter passed in is not an object', () => {
      expect(mockStore.isObject(undefined)).toBe(false)

      expect(mockStore.isObject(null)).toBe(false)

      expect(mockStore.isObject(77)).toBe(false)

      expect(mockStore.isObject([])).toBe(false)

      expect(mockStore.isObject(true)).toBe(false)

      expect(mockStore.isObject('true')).toBe(false)
    })

  })
})
