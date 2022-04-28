import { shallowMount, createLocalVue } from '@vue/test-utils'

import Vuex from 'vuex'
import VTooltip from 'v-tooltip'
import Vue2Filters from 'vue2-filters'

import state from 'judge/scores/store/state'
import mockStore from 'judge/scores/store/__mocks__'
import QuestionSection from 'judge/scores/QuestionSection'

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
        sectionPointsTotal: jest.fn(() => () => 10),
        sectionPointsPossible: jest.fn(() => () => 10),
      }, mutations: {
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

  test('saves comments after changes', async() => {
    const storeCommitSpy = jest.spyOn(wrapper.vm.$store, 'commit')

    wrapper.vm.comment.text = 'hello'
    await wrapper.vm.$nextTick()

    wrapper.vm.handleCommentChange()
    await wrapper.vm.$nextTick()

    expect(storeCommitSpy).toHaveBeenLastCalledWith('saveComment', 'ideation')
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
      }
    )

    const handleCommentChangeSpy = jest.spyOn(wrapper.vm, 'handleCommentChange')

    expect(handleCommentChangeSpy).not.toHaveBeenCalled()

    wrapper.vm.debouncedCommentWatcher()

    jest.runAllTimers()

    expect(handleCommentChangeSpy).toHaveBeenCalled()
  })

  test('it resets the word count when the text is deleted', async() => {
    wrapper.vm.comment.text = 'hello beautiful world'
    await wrapper.vm.$nextTick()

    expect(wrapper.vm.comment.word_count).toEqual(3)

    wrapper.vm.comment.text = ''
    await wrapper.vm.$nextTick()

    expect(wrapper.vm.comment.word_count).toEqual(0)
  })

  describe('minWordCount()', () => {
    it('returns 20 for the ideation section', () => {
      wrapper.setProps({ section: 'ideation' })

      expect(wrapper.vm.minWordCount).toEqual(20)
    })

    it('returns 20 for the technical section', () => {
      wrapper.setProps({ section: 'technical' })

      expect(wrapper.vm.minWordCount).toEqual(20)
    })

    it('returns 20 for the pitch section', () => {
      wrapper.setProps({ section: 'pitch' })

      expect(wrapper.vm.minWordCount).toEqual(20)
    })

    it('returns 20 for the entrepreneurship section', () => {
      storeMocks = mockStore.createMocks({
        state: { team: { division: 'senior' }}
      })

      wrapper = shallowMount(
        QuestionSection, {
          store: storeMocks.store,
          localVue,
          propsData: {
            section: 'entrepreneurship'
          }
        }
      )

      expect(wrapper.vm.minWordCount).toEqual(20)
    })
  })

  describe('colorForWordCount()', () => {
    describe('when the minimum word count (for the comments section) is 20', () => {
      beforeEach(() => {
        wrapper.setProps({ section: 'pitch' })
      })

      it('returns a red color when no words have been entered', () => {
        wrapper.vm.comment.text = ''

        expect(wrapper.vm.colorForWordCount).toEqual('#ef4444')
      })

      it('returns an orange color when 1/3 of the mimumum word count has been entered', () => {
        wrapper.vm.comment.text = 'one two three four five six seven'

        expect(wrapper.vm.colorForWordCount).toEqual('#f97316')
      })

      it('returns a yellow color when 2/3 of the minimum word count has been entered', () => {
        wrapper.vm.comment.text = `one two three four five six seven eight nine ten
          eleven twelve thirteen fourteen`

        expect(wrapper.vm.colorForWordCount).toEqual('#eab308')
      })

      it('returns a green color when the miniumum word count has been met', () => {
        wrapper.vm.comment.text = `one two three four five six seven eight nine ten
          eleven twelve thirteen fourteen fifteen sixteen seventeen eighteen nineteen twenty`

        expect(wrapper.vm.colorForWordCount).toEqual('#43b02a')
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
