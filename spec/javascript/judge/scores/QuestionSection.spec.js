import { shallow, createLocalVue } from '@vue/test-utils'

import Vuex from 'vuex'
import VTooltip from 'v-tooltip'
import Vue2Filters from 'vue2-filters'

import state from 'judge/scores/store/state'
import { __createMocks as createMocks } from "judge/scores/store/__mocks__"
import QuestionSection from "judge/scores/QuestionSection"

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

    storeMocks = createMocks({
      state: initialState,
      getters: {
        sectionQuestions: jest.fn(() => () => {}),
      }
    })

    wrapper = shallow(
      QuestionSection, {
        store: storeMocks.store,
        localVue,
        propsData: {
          section: "ideation",
        },
      }
    )
  })

  test("initiates the comment on mount", (done) => {
    wrapper.vm.$nextTick().then(() => {
      expect(wrapper.vm.commentInitiated).toBe(true)
      done()
    })
  })

  test("sets the comment storage with section name and score ID", (done) => {
    wrapper.vm.$nextTick().then(() => {
      expect(wrapper.vm.commentStorageKey).toEqual("ideation-comment-1")
      done()
    })
  })

  test("it resets the word count when the text is deleted", (done) => {
    wrapper.vm.$nextTick().then(() => {
      wrapper.vm.comment.text = "hello beautiful world"

      wrapper.vm.$nextTick().then(() => {
        expect(wrapper.vm.comment.word_count).toEqual(3)

        wrapper.vm.comment.text = ""

        wrapper.vm.$nextTick().then(() => {
          expect(wrapper.vm.comment.word_count).toEqual(0)
          done()
        })
      })
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

  storeMocks = createMocks({
    state: initialState,
  })

  wrapper = shallow(
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
