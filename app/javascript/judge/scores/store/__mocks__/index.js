import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

export const getters = {
  comment: jest.fn(() => (sectionName) => state.score.comments[sectionName]),
  sectionQuestions: jest.fn(() => () => {}),
}

export const mutations = {
  setComment: (state, commentData) => {
    const originalComment = state.score.comments[commentData.sectionName]
    const comment = Object.assign({}, originalComment, commentData)

    state.score.comments[commentData.sectionName] = comment
  },

  resetComment: (state, sectionName) => {
    const originalComment = state.score.comments[sectionName]
    const comment = Object.assign({}, originalComment, {
      text: '',
      isProfanityAnalyzed: false,
      isSentimentAnalyzed: false,
      sentiment: {
        negative: 0,
        positive: 0,
        neutral: 0,
      },
      bad_word_count: 0,
      word_count: 0,
    })

    state.score.comments[sectionName] = comment
  }
}

export const actions = {}

const emptyComment = {
  text: '',

  sentiment: {
    negative: 0,
    positive: 0,
    neutral: 0,
  },

  bad_word_count: 0,
  word_count: 0,

  isSentimentAnalyzed: false,
  isProfanityAnalyzed: false,
}

export const state = {
  submission: {
    id: 1,
  },

  score: {
    id: null,
    comments: {
      ideation: emptyComment,
      technical: emptyComment,
      entrepreneurship: emptyComment,
      pitch: emptyComment,
      overall: emptyComment,
    },
  },
}

// eslint-disable-next-line no-underscore-dangle
export function __createMocks(custom = { getters: {}, mutations: {}, actions: {}, state: {} }) {
  const mockGetters = Object.assign({}, getters, custom.getters)
  const mockMutations = Object.assign({}, mutations, custom.mutations)
  const mockActions = Object.assign({}, actions, custom.actions)
  const mockState = Object.assign({}, state, custom.state)

  return {
    getters: mockGetters,
    mutations: mockMutations,
    actions: mockActions,
    state: mockState,
    store: new Vuex.Store({
      getters: mockGetters,
      mutations: mockMutations,
      actions: mockActions,
      state: mockState,
    }),
  }
}

export const store = __createMocks().store