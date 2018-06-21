import $ from 'jquery'
import { shallow, createLocalVue } from '@vue/test-utils'
import VueDragula from 'vue-dragula'

// We need to expose these globally since they are exposed globally in
// application.js via Ruby
const localVue = createLocalVue()
localVue.use(VueDragula)
window.vueDragula = localVue.vueDragula
window.$ = $

import ScreenshotUploader from 'components/ScreenshotUploader'

describe('ScreenshotUploader Vue component', () => {

  describe('props', () => {

    it('contains valid sortUrl, screenshotsUrl, and teamId properties', () => {
      expect(ScreenshotUploader.props).toEqual({
        sortUrl: {
          type: String,
          required: true,
        },

        screenshotsUrl: {
          type: String,
          required: true,
        },

        teamId: {
          type: Number,
          required: true,
        },
      })
    })

  })

  describe('data', () => {

    it('returns an object with the proper initialization', () => {
      expect(ScreenshotUploader.data()).toEqual({
        maxAllowed: 6,
        screenshots: [],
        uploads: [],
      })
    })

  })

  describe('computed properties', () => {

    it('maxFiles returns the the number of screenshots remaining for upload', () => {
      const wrapper = shallow(ScreenshotUploader, {
        localVue,
        propsData: {
          screenshotsUrl: '/student/screenshots',
          sortUrl: '/student/team_submissions/no-name-yet-by-all-star-team',
          teamId: 1,
        },
      })

      for (let i = 1; i <= wrapper.vm.maxAllowed; i += 1) {
        wrapper.vm.screenshots.push({
          id: i,
          src: `https://s3.amazonaws.com/technovation-uploads-dev/${i}.png`,
          name: null,
          large_img_url: `https://s3.amazonaws.com/technovation-uploads-dev/large_${i}.png`,
        })

        expect(wrapper.vm.maxFiles).toEqual(wrapper.vm.maxAllowed - i)
      }
    })

  })

})