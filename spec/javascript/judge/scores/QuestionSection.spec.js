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

test("initiates the comment on mount", (done) => {
  const wrapper = shallow(QuestionSection, { store, localVue })

  wrapper.vm.$nextTick().then(() => {
    expect(wrapper.vm.commentInitiated).toBe(true)
    done()
  })
})
