import { shallow, createLocalVue } from '@vue/test-utils'

import Vuex from 'vuex'
import VTooltip from 'v-tooltip'
import Vue2Filters from 'vue2-filters'

import { store } from "judge/scores/store/__mocks__"
import QuestionSection from "judge/scores/QuestionSection"

const localVue = createLocalVue()

localVue.use(Vuex)
localVue.use(VTooltip)
localVue.use(Vue2Filters)

let wrapper

beforeEach(() => {
  wrapper = shallow(
    QuestionSection,
    {
      store,
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