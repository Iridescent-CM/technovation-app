import { shallowMount, createLocalVue } from '@vue/test-utils'

import Vuex from 'vuex'
import VTooltip from 'v-tooltip'
import Vue2Filters from 'vue2-filters'

import state from 'judge/scores/store/state'
import mockStore from 'judge/scores/store/__mocks__'
import QuestionSection from 'judge/scores/QuestionSection'

const sentimentResponse = [
  {
    compound: 0.508,
    negative: 0.14500000000000002,
    neutral: 0.521,
    positive: 0.3350000000000001,
    sentence: 'This old product sucks! But after the update it works like a charm!',
  }
];

const profanityResponse = {
  ass: 1,
  damn: 1,
  jackass: 1,
  frack: 1,
};

// This is an anti-pattern. Since we aren't pulling in Algorithmia from npm we
// have to mock the module directly. If we were pulling in via node_modules we
// could use: jest.mock('Algorithmia')
window.Algorithmia = {
  client: () => ({
    algo: (algorithm) => ({
      pipe: () => {
        if (algorithm === 'nlp/SocialSentimentAnalysis/0.1.4') {
          return Promise.resolve({
            result: sentimentResponse,
          })
        } else if (algorithm === 'nlp/ProfanityDetection/1.0.0') {
          return Promise.resolve(profanityResponse)
        }
      }
    })
  })
}

const localVue = createLocalVue()

localVue.use(Vuex)
localVue.use(VTooltip)
localVue.use(Vue2Filters)

let wrapper
let storeMocks
let initialState

describe('Question comments section', () => {
  beforeEach(() => {
    initialState = Object.assign({}, state);
    initialState.submission.id = 1;

    storeMocks = mockStore.createMocks({
      state: initialState,
      getters: {
        sectionQuestions: jest.fn(() => () => {}),
      },
      mutations: {
        saveComment: jest.fn(() => {}),
      },
    })

    wrapper = shallowMount(
      QuestionSection, {
        store: storeMocks.store,
        localVue,
        propsData: {
          section: 'ideation',
        },
      }
    )
  })

  test('initiates the comment on mount', (done) => {
    wrapper.vm.$nextTick().then(() => {
      expect(wrapper.vm.commentInitiated).toBe(true)
      done()
    })
  })

  test('sets the comment storage with section name and score ID', (done) => {
    wrapper.vm.$nextTick().then(() => {
      expect(wrapper.vm.commentStorageKey).toEqual('ideation-comment-1')
      done()
    })
  })

  test('saves comments after changes, even if analysis does not run', (done) => {
    const storeCommitSpy = jest.spyOn(wrapper.vm.$store, 'commit')

    wrapper.vm.comment.isProfanityAnalyzed = true
    wrapper.vm.comment.text = 'hello wo'

    wrapper.vm.handleCommentChange()

    setImmediate(() => {
      expect(storeCommitSpy).toHaveBeenLastCalledWith('saveComment', 'ideation')
      done()
    })
  })

  test('debouncedCommentWatcher calls handleCommentChange', () => {
    jest.useFakeTimers()

    wrapper = shallowMount(
      QuestionSection, {
        store: storeMocks.store,
        localVue,
        propsData: {
          section: 'ideation',
        },
        computed: {
          shouldRunSentimentAnalysis: () => true,
          shouldRunProfanityAnalysis: () => true,
        },
      }
    )

    const handleCommentChangeSpy = jest.spyOn(wrapper.vm, 'handleCommentChange')

    expect(handleCommentChangeSpy).not.toHaveBeenCalled()

    wrapper.vm.debouncedCommentWatcher()

    jest.runAllTimers()

    expect(handleCommentChangeSpy).toHaveBeenCalled()
  })

  test('saves comments after changes, if analysis is run', (done) => {
    wrapper = shallowMount(
      QuestionSection, {
        store: storeMocks.store,
        localVue,
        propsData: {
          section: 'ideation',
        },
        computed: {
          shouldRunSentimentAnalysis: () => true,
          shouldRunProfanityAnalysis: () => true,
        },
      }
    )

    const storeCommitSpy = jest.spyOn(wrapper.vm.$store, 'commit')

    wrapper.vm.handleCommentChange()

    setImmediate(() => {
      expect(storeCommitSpy).toHaveBeenLastCalledWith('saveComment', 'ideation')
      done()
    })
  })

  test('sets comment after sentiment analysis is run', (done) => {
    wrapper = shallowMount(
      QuestionSection, {
        store: storeMocks.store,
        localVue,
        propsData: {
          section: 'ideation',
        },
        computed: {
          shouldRunSentimentAnalysis: () => true,
        },
      }
    )

    const storeCommitSpy = jest.spyOn(wrapper.vm.$store, 'commit')

    wrapper.vm.runSentimentAnalysis().then(() => {
      expect(storeCommitSpy).toHaveBeenLastCalledWith('setComment', {
        sectionName: 'ideation',
        sentiment: sentimentResponse[0],
        isSentimentAnalyzed: true,
      })
      done()
    })
  })

  test('sets comment after profanity analysis is run', (done) => {
    wrapper = shallowMount(
      QuestionSection, {
        store: storeMocks.store,
        localVue,
        propsData: {
          section: 'ideation',
        },
        computed: {
          shouldRunProfanityAnalysis: () => true,
          badWordCount: () => 4,
        },
      }
    )

    const storeCommitSpy = jest.spyOn(wrapper.vm.$store, 'commit')

    wrapper.vm.runProfanityAnalysis().then(() => {
      expect(storeCommitSpy).toHaveBeenLastCalledWith('setComment', {
        sectionName: 'ideation',
        bad_word_count: wrapper.vm.badWordCount,
        isProfanityAnalyzed: true,
      })
      done()
    })
  })

  test('it resets the word count when the text is deleted', (done) => {
    wrapper.vm.$nextTick(() => {
      wrapper.vm.comment.text = 'hello beautiful world'

      wrapper.vm.$nextTick(() => {
        expect(wrapper.vm.comment.word_count).toEqual(3)

        wrapper.vm.comment.text = ''

        wrapper.vm.$nextTick(() => {
          expect(wrapper.vm.comment.word_count).toEqual(0)
          done()
        })
      })
    })
  })

  test('textarea should update comment text in store on change', (done) => {
    wrapper = shallowMount(
      QuestionSection, {
        store: storeMocks.store,
        localVue,
        propsData: {
          section: 'ideation',
        },
        attachToDocument: true
      }
    )

    const comment = 'This is a pretty great project. I like what I see here.'

    wrapper.vm.$refs.commentText.value = comment

    const inputEvent = document.createEvent('HTMLEvents');
    inputEvent.initEvent('input', true, true);
    wrapper.vm.$refs.commentText.dispatchEvent(inputEvent);

    wrapper.vm.$nextTick().then(() => {
      expect(wrapper.vm.comment.text).toEqual(comment)
      expect(wrapper.vm.commentText).toEqual(comment)

      wrapper.destroy()

      done()
    })
  })
})

test('Getter sectionQuestions returns a filtered array based on the current section in the store', () => {
  const section = 'ideation'

  const question1 = {
    section: 'ideation',
    question: 'This is a mock question',
  };

  const question2 = {
    section: 'ideation',
    question: 'This is another mock question',
  }

  const question3 = {
    section: 'ideation',
    question: 'This is a third mock question',
  }

  const expectedQuestions = [
    question1,
    question2,
    question3,
  ]

  initialState = Object.assign({}, state);
  initialState.questions = [
    {
      section: 'should_be_filtered_out',
      question: 'Filtered question one',
    },
    question1,
    {
      section: 'should_be_filtered_out',
      question: 'Filtered question two',
    },
    question2,
    question3,
  ]

  storeMocks = mockStore.createMocks({
    state: initialState,
  })

  wrapper = shallowMount(
    QuestionSection, {
      store: storeMocks.store,
      localVue,
      propsData: {
        section,
      },
    }
  )

  const filteredQuestions = wrapper.vm.sectionQuestions(section);

  expect(filteredQuestions).toEqual(expectedQuestions);
})

describe('shouldRunSentimentAnalysis', () => {
  it('runs if word count is greater than 19 and it has not yet been analyzed', () => {
    wrapper = shallowMount(
      QuestionSection, {
        store: storeMocks.store,
        localVue,
        propsData: {
          section: 'ideation',
        },
        computed: {
          commentIsSentimentAnalyzed: () => false,
          wordCount: () => 21,
        },
      }
    )

    expect(wrapper.vm.shouldRunSentimentAnalysis).toBe(true)
  })

  it('runs if word count is greater than 19, it has been analyzed, ' +
    'and the word count is divisible by 5', () => {
      wrapper = shallowMount(
        QuestionSection, {
          store: storeMocks.store,
          localVue,
          propsData: {
            section: 'ideation',
          },
          computed: {
            commentIsSentimentAnalyzed: () => true,
            wordCount: () => 25,
          },
        }
      )

      expect(wrapper.vm.shouldRunSentimentAnalysis).toBe(true)
  })

  it('does not run if word count is greater than 19, it has been analyzed, ' +
    'and the word count is not divisible by 5', () => {
      wrapper = shallowMount(
        QuestionSection, {
          store: storeMocks.store,
          localVue,
          propsData: {
            section: 'ideation',
          },
          computed: {
            commentIsSentimentAnalyzed: () => true,
            wordCount: () => 23,
          },
        }
      )

      expect(wrapper.vm.shouldRunSentimentAnalysis).toBe(false)
  })
})

describe('shouldRunProfanityAnalysis', () => {
  it('runs if word count is greater than 0 and it has not yet been analyzed', () => {
    wrapper = shallowMount(
      QuestionSection, {
        store: storeMocks.store,
        localVue,
        propsData: {
          section: 'ideation',
        },
        computed: {
          commentIsProfanityAnalyzed: () => false,
          wordCount: () => 3,
        },
      }
    )

    expect(wrapper.vm.shouldRunProfanityAnalysis).toBe(true)
  })

  it('runs if word count is greater than 0, it has been analyzed, ' +
    'and the word count is divisible by 2', () => {
      wrapper = shallowMount(
        QuestionSection, {
          store: storeMocks.store,
          localVue,
          propsData: {
            section: 'ideation',
          },
          computed: {
            commentIsProfanityAnalyzed: () => true,
            wordCount: () => 6,
          },
        }
      )

      expect(wrapper.vm.shouldRunProfanityAnalysis).toBe(true)
  })

  it('does not run if word count is greater than 0, it has been analyzed, ' +
    'and the word count is not divisible by 2', () => {
      wrapper = shallowMount(
        QuestionSection, {
          store: storeMocks.store,
          localVue,
          propsData: {
            section: 'ideation',
          },
          computed: {
            commentIsProfanityAnalyzed: () => true,
            wordCount: () => 3,
          },
        }
      )

      expect(wrapper.vm.shouldRunProfanityAnalysis).toBe(false)
  })
})