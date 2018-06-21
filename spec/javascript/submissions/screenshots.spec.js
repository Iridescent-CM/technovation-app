import $ from 'jquery'
import { shallow, createLocalVue } from '@vue/test-utils'
import VueDragula from 'vue-dragula'

// We need to expose these globally since they are exposed globally in
// application.js via Ruby
const localVue = createLocalVue()
localVue.use(VueDragula)
window.vueDragula = localVue.vueDragula

// TODO - Refactor out jQuery once tests are to a good state
// Replace with axios
window.$ = $
window.$.ajax = jest.fn(() => {})

import ScreenshotUploader from 'components/ScreenshotUploader'

describe('ScreenshotUploader Vue component', () => {

  let wrapper

  beforeEach(() => {
    wrapper = shallow(ScreenshotUploader, {
      localVue,
      propsData: {
        screenshotsUrl: '/student/screenshots',
        sortUrl: '/student/team_submissions/no-name-yet-by-all-star-team',
        teamId: 1,
      },
    })

    $.ajax.mockClear()
  })

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

    describe('maxFiles', () => {

      it('returns the the number of screenshots remaining for upload', () => {
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

    describe('object', () => {

      it('returns "screenshots" if more than one file upload remains', () => {
        expect(wrapper.vm.maxFiles).toBeGreaterThan(1)
        expect(wrapper.vm.object).toEqual('screenshots')
      })

      it('returns "screenshot" if only one file upload remains', () => {
        wrapper = shallow(ScreenshotUploader, {
          localVue,
          propsData: {
            screenshotsUrl: '/student/screenshots',
            sortUrl: '/student/team_submissions/no-name-yet-by-all-star-team',
            teamId: 1,
          },
          computed: {
            maxFiles () {
              return 1
            },
          },
        })

        expect(wrapper.vm.object).toEqual('screenshot')
      })

    })

    describe('prefix', () => {

      it('returns "up to" if more than one file upload remains', () => {
        expect(wrapper.vm.maxFiles).toBeGreaterThan(1)
        expect(wrapper.vm.prefix).toEqual('up to')
      })

      it('returns "" if only one file upload remains', () => {
        wrapper = shallow(ScreenshotUploader, {
          localVue,
          propsData: {
            screenshotsUrl: '/student/screenshots',
            sortUrl: '/student/team_submissions/no-name-yet-by-all-star-team',
            teamId: 1,
          },
          computed: {
            maxFiles () {
              return 1
            },
          },
        })

        expect(wrapper.vm.prefix).toEqual('')
      })

    })

  })

  describe('methods', () => {

    describe('removeScreenshot', () => {

      const screenshot = {
        id: 1,
        src: `https://s3.amazonaws.com/technovation-uploads-dev/1.png`,
        name: null,
        large_img_url: `https://s3.amazonaws.com/technovation-uploads-dev/large_1.png`,
      }

      const screenshotTwo = {
        id: 2,
        src: `https://s3.amazonaws.com/technovation-uploads-dev/2.png`,
        name: null,
        large_img_url: `https://s3.amazonaws.com/technovation-uploads-dev/large_2.png`,
      }

      beforeAll(() => {
        window.swal = jest.fn()

        window.swal.mockImplementation(() => {
          return Promise.resolve()
        })
      })

      afterAll(() => {
        window.swal.mockRestore()
      })

      beforeEach(() => {
        wrapper.vm.screenshots.push(screenshot)
        wrapper.vm.screenshots.push(screenshotTwo)
      })

      it('calls swal with the correct settings', () => {
        wrapper.vm.removeScreenshot(screenshot)

        expect(swal).toHaveBeenCalledWith({
          text: "Are you sure you want to delete the screenshot?",
          cancelButtonText: "No, go back",
          confirmButtonText: "Yes, delete it",
          confirmButtonColor: "#D8000C",
          showCancelButton: true,
          reverseButtons: true,
          focusCancel: true,
        })
      })

      it('removes the screenshot from the screenshots array when alert is confirmed', (done) => {
        expect(wrapper.vm.screenshots).toHaveLength(2)
        expect(wrapper.vm.screenshots).toContain(screenshot)
        expect(wrapper.vm.screenshots).toContain(screenshotTwo)

        wrapper.vm.removeScreenshot(screenshot)

        setImmediate(() => {
          expect(wrapper.vm.screenshots).toHaveLength(1)
          expect(wrapper.vm.screenshots).not.toContain(screenshot)
          expect(wrapper.vm.screenshots).toContain(screenshotTwo)
          done()
        })
      })

      it('removes the screenshot from the database via AJAX call when alert is confirmed', (done) => {
        wrapper.vm.removeScreenshot(screenshot)

        setImmediate(() => {
          expect($.ajax).toHaveBeenCalledWith({
            method: "DELETE",
            url: wrapper.vm.screenshotsUrl +
                  "/" +
                  screenshot.id +
                  "?team_id=" +
                  wrapper.vm.teamId,
          })
          done()
        })
      })

    })

  })
})