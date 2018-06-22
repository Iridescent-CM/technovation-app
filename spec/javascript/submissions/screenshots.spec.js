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

  const screenshot = {
    id: 1,
    src: 'https://s3.amazonaws.com/technovation-uploads-dev/1.png',
    name: null,
    large_img_url: 'https://s3.amazonaws.com/technovation-uploads-dev/large_1.png',
  }

  const screenshotTwo = {
    id: 2,
    src: 'https://s3.amazonaws.com/technovation-uploads-dev/2.png',
    name: null,
    large_img_url: 'https://s3.amazonaws.com/technovation-uploads-dev/large_2.png',
  }

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

  describe('data', () => {

    it('returns an object with the proper initialization', () => {
      expect(ScreenshotUploader.data()).toEqual({
        maxAllowed: 6,
        screenshots: [],
        uploads: [],
      })
    })

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

  describe('mounted lifecycle hook', () => {

    beforeAll(() => {
      jest.useFakeTimers()
    })

    it('loads the previously saved screenshots via AJAX', () => {
      expect($.ajax).not.toHaveBeenCalled()

      wrapper = shallow(ScreenshotUploader, {
        localVue,
        propsData: {
          screenshotsUrl: '/student/screenshots',
          sortUrl: '/student/team_submissions/no-name-yet-by-all-star-team',
          teamId: 1,
        },
      })

      expect($.ajax).toHaveBeenCalledWith({
        method: 'GET',
        url: `${wrapper.vm.screenshotsUrl}?team_id=${wrapper.vm.teamId}`,
        success: expect.any(Function),
      })

      // Mock the success callback for the AJAX request
      $.ajax.mock.calls[0][0].success([
        screenshot,
        screenshotTwo,
      ])

      expect(wrapper.vm.screenshots).toEqual([
        screenshot,
        screenshotTwo,
      ])
    })

    // TODO - Refactor this test into much smaller pieces
    // First we need to refactor the code into smaller chunks and make sure
    // this test doesn't break.
    it('sets up VueDragula drop event handler', (done) => {
      wrapper.vm.screenshots.push(screenshot)
      wrapper.vm.screenshots.push(screenshotTwo)

      wrapper.vm.$nextTick(() => {
        const vueDragulaArgs = [
          'globalBag',
          wrapper.find('li.sortable-list__item.draggable:first-child').element,
          wrapper.find('ol#sortable-list.sortable-list.submission-pieces__screenshots').element,
          wrapper.find('ol#sortable-list.sortable-list.submission-pieces__screenshots').element,
          wrapper.find('li.sortable-list__item.draggable:last-child').element,
        ]

        window.vueDragula.eventBus.$emit('drop', vueDragulaArgs)

        wrapper.vm.$nextTick(() => {
          const form = new FormData()

          form.append(
            'team_submission[screenshots][]',
            vueDragulaArgs[1].dataset.dbId
          )

          form.append(
            'team_submission[screenshots][]',
            vueDragulaArgs[4].dataset.dbId
          )

          form.append('team_id', wrapper.vm.teamId);

          expect($.ajax).toHaveBeenCalledWith({
            method: 'PATCH',
            url: wrapper.vm.sortUrl,
            data: form,
            contentType: false,
            processData: false,
            success: expect.any(Function),
          })

          $.ajax.mock.calls[0][0].success()

          expect(vueDragulaArgs[1].classList).toContain('sortable-list--updated')

          jest.advanceTimersByTime(1000)

          expect(vueDragulaArgs[1].classList).not.toContain('sortable-list--updated')

          done()
        })

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
          text: 'Are you sure you want to delete the screenshot?',
          cancelButtonText: 'No, go back',
          confirmButtonText: 'Yes, delete it',
          confirmButtonColor: '#D8000C',
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
            method: 'DELETE',
            url: wrapper.vm.screenshotsUrl +
                  '/' +
                  screenshot.id +
                  '?team_id=' +
                  wrapper.vm.teamId,
          })
          done()
        })
      })

    })

    describe('handleFileInput', () => {

      const firstImage = new File(
        [''],
        'Screen Shot 2018-06-04 at 4.30.00 PM.png',
        { type: 'image/png' }
      )

      const secondImage = new File(
        [''],
        'Screen Shot 2018-06-04 at 5.00.00 PM.png',
        { type: 'image/png' }
      )

      let fileUploadEventMock

      beforeEach(() => {
        fileUploadEventMock = {
          target: {
            files: [
              firstImage,
              secondImage,
            ],
            value: 'Screen Shot 2018-06-04 at 4.30.00 PM.png',
          },
        }
      })

      it('adds the file input images to the uploads array', (done) => {
        wrapper.vm.handleFileInput(fileUploadEventMock)

        setImmediate(() => {
          expect(wrapper.vm.uploads).toEqual([
            firstImage,
            secondImage,
          ])
          done()
        })
      })

      it('calls AJAX with the correct parameters', (done) => {
        wrapper.vm.handleFileInput(fileUploadEventMock)

        setImmediate(() => {
          expect($.ajax).toHaveBeenCalledTimes(2)

          const imageFiles = [
            firstImage,
            secondImage,
          ]

          imageFiles.forEach((file) => {
            const form = new FormData();

            form.append('team_submission[screenshots_attributes][]image', file)
            form.append('team_id', wrapper.vm.teamId)

            expect($.ajax).toHaveBeenCalledWith({
              method: 'POST',
              url: wrapper.vm.screenshotsUrl,
              data: form,
              contentType: false,
              processData: false,
              success: expect.any(Function),
            })
          })

          done()
        })
      })

      describe('AJAX success callback', () => {

        // Please note that these tests will become cleaner once we pull the
        // success callback out of the actual AJAX call

        it('adds each image object to the screenshots array', (done) => {
          wrapper.vm.screenshots = []
          wrapper.vm.handleFileInput(fileUploadEventMock)

          setImmediate(() => {
            expect(wrapper.vm.screenshots).toHaveLength(0)
            expect($.ajax).toHaveBeenCalledTimes(2)

            $.ajax.mock.calls[0][0].success(screenshot)
            $.ajax.mock.calls[0][0].success(screenshotTwo)

            expect(wrapper.vm.screenshots).toEqual([
              screenshot,
              screenshotTwo,
            ])

            done()
          })
        })

        it('removes each file object from the uploads array', (done) => {
          wrapper.vm.handleFileInput(fileUploadEventMock)

          setImmediate(() => {
            expect(wrapper.vm.uploads).toHaveLength(2)
            expect($.ajax).toHaveBeenCalledTimes(2)

            $.ajax.mock.calls[0][0].success(screenshot)
            $.ajax.mock.calls[1][0].success(screenshotTwo)

            expect(wrapper.vm.uploads).toHaveLength(0)

            done()
          })
        })

        it('sets the file input element value to ""', (done) => {
          expect(fileUploadEventMock.target.value)
            .toEqual('Screen Shot 2018-06-04 at 4.30.00 PM.png')

          wrapper.vm.handleFileInput(fileUploadEventMock)

          setImmediate(() => {
            $.ajax.mock.calls[0][0].success(screenshot)
            expect(fileUploadEventMock.target.value).toEqual('')
            done()
          })
        })
      })

    })

  })

})