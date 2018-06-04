import { shallow, createLocalVue } from '@vue/test-utils'

import Vuex from 'vuex'

import { store } from "judge/scores/store/__mocks__"
import QuestionSection from "judge/scores/QuestionSection"

const localVue = createLocalVue()

localVue.use(Vuex)

test("initiates the comment on mount", (done) => {
  const wrapper = shallow(QuestionSection, { store, localVue })

  wrapper.vm.$nextTick().then(() => {
    expect(wrapper.vm.commentInitiated).toBe(true)
    done()
  })
})
