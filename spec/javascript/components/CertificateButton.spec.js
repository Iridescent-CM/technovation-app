import { shallow } from '@vue/test-utils'

import axios from 'axios'
import Icon from 'components/Icon'
import CertificateButton from 'components/CertificateButton'

describe('CertificateButton Vue component', () => {
  // Mocking this out to prevent console from getting bogged down with warnings
  // We will want to move this into a proper mock later on
  axios.get = jest.fn()
  axios.post = jest.fn()

  axios.post.mockImplementation(() => {
    return Promise.resolve({
      jobId: 5,
    })
  })
  axios.get.mockImplementation(() => {
    return Promise.resolve({
      status: 'complete',
    })
  })

  beforeEach(() => {
    axios.post.mockClear()
    axios.get.mockClear()
  })

  describe('props', () => {
    it('defaults teamId to 0', () => {
      const wrapper = shallow(CertificateButton, {
        propsData: {
          userScope: 'mentor',
        },
      })

      expect(CertificateButton.props.teamId).toEqual({
        type: Number,
        default: 0,
      })

      expect(wrapper.vm.teamId).toEqual(0)
    })
  })

  it('sets the correct initial data state', () => {
    expect(CertificateButton.data()).toEqual({
      fileUrl: null,
      jobId: null,
      state: 'requesting',
    })
  })

  describe('markup', () => {
    it('displays a loading spinner if the certificate button URL ' +
      'is being requested', (done) => {
      const wrapper = shallow(CertificateButton, {
        propsData: {
          userScope: 'mentor',
        },
      })

      wrapper.vm.state = 'requesting'

      wrapper.vm.$nextTick(() => {
        const componentHasButton = wrapper.contains({
          ref: 'certificateButton',
        })

        expect(wrapper.contains(Icon)).toBe(true)
        expect(wrapper.find('span').html())
          .toEqual('<span>Requesting certificate...</span>')
        expect(componentHasButton).toBe(false)
        done()
      })
    })

    it('displays a loading spinner if the certificate button URL ' +
      'is being generated', (done) => {
      const wrapper = shallow(CertificateButton, {
        propsData: {
          userScope: 'mentor',
        },
      })

      wrapper.vm.state = 'generating'

      wrapper.vm.$nextTick(() => {
        const componentHasButton = wrapper.contains({
          ref: 'certificateButton',
        })

        expect(wrapper.contains(Icon)).toBe(true)
        expect(wrapper.find('span').html())
          .toEqual('<span>Generating certificate...</span>')
        expect(componentHasButton).toBe(false)
        done()
      });
    })

    it('displays a link to the certificate if the certificate button URL ' +
      'has finished being generated', (done) => {
      const url = '/this/is/a/test/url'
      const wrapper = shallow(CertificateButton, {
        propsData: {
          userScope: 'mentor',
        },
      })

      wrapper.vm.state = 'ready'
      wrapper.vm.fileUrl = url

      wrapper.vm.$nextTick(() => {
        const button = wrapper
          .find({
            ref: 'certificateButton',
          })

        expect(wrapper.contains(Icon)).toBe(false)
        expect(wrapper.contains('span')).toBe(false)
        expect(button.exists()).toBe(true)
        expect(button.classes()).toContain('button')
        expect(button.attributes().href).toContain(url)
        expect(button.text()).toEqual('Open your certificate')
        done()
      });
    })
  })

  describe('methods', () => {
    describe('createJob', () => {
      it('sets the state to "generating"', () => {
        const wrapper = shallow(CertificateButton, {
          propsData: {
            userScope: 'mentor',
          },
        })

        wrapper.vm.state = 'requesting'

        wrapper.vm.createJob()

        expect(wrapper.vm.state).toEqual('generating')
      })

      it('sends a POST request to the request endpoint', () => {
        const wrapper = shallow(CertificateButton, {
          propsData: {
            userScope: 'mentor',
          },
        })

        axios.post.mockClear()

        expect(axios.post).not.toHaveBeenCalled()

        wrapper.vm.createJob()

        expect(axios.post).toHaveBeenCalledWith('/mentor/certificates/')
      })
    })

    describe('handleJobRequest', () => {
      it('sets the job id to that of the response', () => {
        const response = {
          jobId: 8,
        }

        const wrapper = shallow(CertificateButton, {
          propsData: {
            userScope: 'mentor',
          },
        })

        expect(wrapper.vm.jobId).toBeNull()

        wrapper.vm.handleJobRequest(response)

        expect(wrapper.vm.jobId).toEqual(response.jobId)
      })

      it('does not update the job id if the response does not contain ' +
        'a valid jobId', () => {
        const wrapper = shallow(CertificateButton, {
          propsData: {
            userScope: 'mentor',
          },
        })

        expect(wrapper.vm.jobId).toBeNull()

        wrapper.vm.handleJobRequest({ jobId: 0 })

        expect(wrapper.vm.jobId).toBeNull()

        wrapper.vm.handleJobRequest({ noJobId: true })

        expect(wrapper.vm.jobId).toBeNull()

        wrapper.vm.handleJobRequest({ jobId: null })

        expect(wrapper.vm.jobId).toBeNull()
      })
    })

    it('sends a pollJobQueue GET request to the job monitor endpoint', () => {
      const wrapper = shallow(CertificateButton, {
        propsData: {
          userScope: 'mentor',
        },
      })

      axios.get.mockClear()

      expect(axios.get).not.toHaveBeenCalled()

      wrapper.vm.jobId = 6

      wrapper.vm.pollJobQueue()

      expect(axios.get).toHaveBeenCalledWith('/mentor/job_statuses/6')
    })

    describe('handleGenerationRequest', () => {
      it('polls the job status endpoint if the response status is "queued"', () => {
        const response = {
          status: 'queued',
        }

        const wrapper = shallow(CertificateButton, {
          propsData: {
            userScope: 'mentor',
          },
        })

        const pollJobQueueSpy = jest.spyOn(wrapper.vm, 'pollJobQueue')

        expect(pollJobQueueSpy).not.toHaveBeenCalled()

        wrapper.vm.handleGenerationRequest(response)

        expect(pollJobQueueSpy).toHaveBeenCalled()
      })

      it('sets the state to ready if the response status is "complete"', () => {
        const response = {
          status: 'complete',
        }

        const wrapper = shallow(CertificateButton, {
          propsData: {
            userScope: 'mentor',
          },
        })

        expect(wrapper.vm.state).toEqual('generating')

        wrapper.vm.handleGenerationRequest(response)

        expect(wrapper.vm.state).toEqual('ready')
      })
    })
  })

  describe('computed property', () => {
    describe('certificateJobUrl', () => {
      it('appends the team id if it is greater than 0', () => {
        const wrapper = shallow(CertificateButton, {
          propsData: {
            teamId: 9,
            userScope: 'mentor',
          },
        })

        expect(wrapper.vm.certificateJobUrl).toEqual('/mentor/certificates/9')
      })

      it('returns the base url without team id if team id is 0 or null', () => {
        const wrapper = shallow(CertificateButton, {
          propsData: {
            userScope: 'mentor',
          },
        })

        expect(wrapper.vm.certificateJobUrl).toEqual('/mentor/certificates/')

        wrapper.teamId = null

        expect(wrapper.vm.certificateJobUrl).toEqual('/mentor/certificates/')
      })
    })
  })

  // Refactor this test once the logic for populating fileUrl is done
  xit('contains the proper state once all AJAX requests and job have finished', (done) => {
    const wrapper = shallow(CertificateButton, {
      propsData: {
        teamId: 3,
        userScope: 'mentor',
      },
    })

    setImmediate(() => {
      expect(wrapper.vm.certificateUrl).toEqual('/mentor/certificates/3')
      expect(wrapper.vm.jobId).toEqual(5)
      expect(wrapper.vm.state).toEqual('ready')
      done()
    })
  })
})