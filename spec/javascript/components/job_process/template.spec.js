import { shallowMount } from '@vue/test-utils'
import axios from 'axios'

import JobProcessTemplate from 'components/job_process/template'

describe('Job process template Vue component', () => {
  const jobStatusUrl = '/student/team_submission_file_upload_confirmation'
  const redirectUrl = '/student/team_submissions/all-star-submission?piece=source_code'

  describe('data', () => {
    it('sets the correct initial state', () => {
      expect(JobProcessTemplate.data()).toEqual({
        interval: null,
        statusCode: 'init',
      })
    })
  })

  describe('props', () => {
    it('contains valid props', () => {
      expect(JobProcessTemplate.props).toEqual({
        statusUrl: {
          type: String,
          required: true,
        }
      })
    })
  })

  describe('mounted hook', () => {
    jest.useFakeTimers()

    beforeEach(() => {
      axios.get.mockClear()
      axios.mockResponseOnce('get', { status: 'busy' })
      axios.mockResponseOnce('get', { status: 'queued' })
      axios.mockResponse('get', { status: 'complete' })
    })

    it('sets up interval to ping status URL in a loop', (done) => {
      expect(axios.get).not.toHaveBeenCalled()

      const wrapper = shallowMount(JobProcessTemplate, {
        propsData: {
          statusUrl: jobStatusUrl,
        },
      })

      // First interval (busy)
      jest.advanceTimersByTime(501)

      wrapper.vm.$nextTick(() => {
        expect(axios.get).toHaveBeenCalledTimes(1)
        expect(wrapper.vm.statusCode).toEqual('busy')

        // Second Interval (queued)
        jest.advanceTimersByTime(501)

        wrapper.vm.$nextTick(() => {
          expect(axios.get).toHaveBeenCalledTimes(2)
          expect(wrapper.vm.statusCode).toEqual('queued')

          // Third interval (complete)
          jest.advanceTimersByTime(501)

          wrapper.vm.$nextTick(() => {
            expect(axios.get).toHaveBeenCalledTimes(3)
            expect(wrapper.vm.statusCode).toEqual('complete')

            // Interval has been cleared by complete status
            jest.advanceTimersByTime(3000)

            wrapper.vm.$nextTick(() => {
              expect(axios.get).toHaveBeenCalledTimes(3)
              expect(wrapper.vm.statusCode).toEqual('complete')
              done()
            })
          })
        })
      })
    })
  })

  describe('computed properties', () => {
    let wrapper

    beforeEach(() => {
      wrapper = shallowMount(JobProcessTemplate, {
        propsData: {
          statusUrl: jobStatusUrl,
        },
      })

      clearInterval(wrapper.vm.interval)
    })

    afterEach(() => {
      wrapper.destroy()
    })

    describe('showLoading', () => {
      it('returns true if status is not complete or error', () => {
        wrapper.vm.statusCode = 'init'

        expect(wrapper.vm.showLoading).toBe(true)

        wrapper.vm.statusCode = 'busy'

        expect(wrapper.vm.showLoading).toBe(true)

        wrapper.vm.statusCode = 'queued'

        expect(wrapper.vm.showLoading).toBe(true)
      })

      it('returns false if status is complete or error', () => {
        wrapper.vm.statusCode = 'complete'

        expect(wrapper.vm.showLoading).toBe(false)

        wrapper.vm.statusCode = 'error'

        expect(wrapper.vm.showLoading).toBe(false)
      })
    })

    describe('backUrl', () => {
      it('returns back GET parameter from URL if present', () => {
        wrapper.vm.fetchGetParameterValue = jest.fn(() => {
          return redirectUrl
        })

        expect(wrapper.vm.backUrl).toEqual(redirectUrl)
      })

      it('returns "/" if no back GET parameter is present', () => {
        wrapper.vm.fetchGetParameterValue = jest.fn(() => {
          return null
        })

        expect(wrapper.vm.backUrl).toEqual('/')
      })
    })

    describe('statusMsg', () => {
      it('returns correct message for init status', () => {
        wrapper.vm.statusCode = 'init'

        expect(wrapper.vm.statusMsg).toEqual('Creating a job for your file...')
      })

      it('returns correct message for init status', () => {
        wrapper.vm.statusCode = 'queued'

        expect(wrapper.vm.statusMsg).toEqual('Your file is waiting in line...')
      })

      it('returns correct message for init status', () => {
        wrapper.vm.statusCode = 'busy'

        expect(wrapper.vm.statusMsg).toEqual('Your file is being processed...')
      })

      it('returns correct message for init status', () => {
        wrapper.vm.statusCode = 'error'

        expect(wrapper.vm.statusMsg)
          .toEqual('There was an error processing your file, please try again')
      })

      it('returns correct message for init status', () => {
        wrapper.vm.statusCode = 'complete'

        expect(wrapper.vm.statusMsg).toEqual('Your file is ready!')
      })
    })

    describe('statusClass', () => {
      it('returns correct message for init status', () => {
        wrapper.vm.statusCode = 'init'

        expect(wrapper.vm.statusClass).toEqual('yellow')
      })

      it('returns correct message for init status', () => {
        wrapper.vm.statusCode = 'queued'

        expect(wrapper.vm.statusClass).toEqual('green-waiting')
      })

      it('returns correct message for init status', () => {
        wrapper.vm.statusCode = 'busy'

        expect(wrapper.vm.statusClass).toEqual('green-busy')
      })

      it('returns correct message for init status', () => {
        wrapper.vm.statusCode = 'error'

        expect(wrapper.vm.statusClass).toEqual('red')
      })

      it('returns correct message for init status', () => {
        wrapper.vm.statusCode = 'complete'

        expect(wrapper.vm.statusClass).toEqual('green-complete')
      })
    })
  })
})