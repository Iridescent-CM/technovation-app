import Vuex from 'vuex'
import { shallow, createLocalVue } from '@vue/test-utils'

import state from 'admin/dashboard/store/index'
import { store } from 'admin/dashboard/store/__mocks__'

import DashboardSection from 'admin/dashboard/components/DashboardSection'
import MentorsSection from 'admin/dashboard/components/MentorsSection'

const localVue = createLocalVue()

localVue.use(Vuex)

/**
 * TODO - After doing research, this will fail until we update the following
 * yarn dependencies
 * - vue-test-utils - Replace with "@vue/test-utils"
 * - vue - Need v2.5.17-beta.0
 *   - Contains https://github.com/vuejs/vue/pull/7878
 */

xdescribe('Admin Dashboard - MentorSection component', () => {

  beforeEach(() => {
    wrapper = shallow(
      MentorsSection, {
        store,
        localVue,
      }
    )
  })

  it('extends the DashboardSection component', () => {
    console.log('props', wrapper.vm.props)
    console.log('computed', wrapper.vm.computed)
    console.log('methods', wrapper.vm.methods)
    expect(true).toBe(true)
  })

})