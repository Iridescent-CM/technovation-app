import { shallowMount } from '@vue/test-utils'

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
    it('teamId should default to 0', () => {
      const wrapper = shallowMount(CertificateButton, {
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

  it('should set the correct initial data state', () => {
    expect(CertificateButton.data()).toEqual({
      jobId: null,
      state: 'requesting',
    })
  })

  describe('markup', () => {
    it('should display a loading spinner if the certificate button URL ' +
      'is being requested', () => {
      const wrapper = shallowMount(CertificateButton, {
        propsData: {
          userScope: 'mentor',
        },
      })

      wrapper.vm.state = 'requesting'

      const componentHasButton = wrapper.contains({
        ref: 'certificateButton'
      })

      expect(wrapper.contains(Icon)).toBe(true)
      expect(wrapper.find('span').html())
        .toEqual('<span>Requesting certificate...</span>')
      expect(componentHasButton).toBe(false)
    })

    it('should display a loading spinner if the certificate button URL ' +
      'is being generated', () => {
      const wrapper = shallowMount(CertificateButton, {
        propsData: {
          userScope: 'mentor',
        },
      })

      wrapper.vm.state = 'generating'

      const componentHasButton = wrapper.contains({
        ref: 'certificateButton'
      })

      expect(wrapper.contains(Icon)).toBe(true)
      expect(wrapper.find('span').html())
        .toEqual('<span>Generating certificate...</span>')
      expect(componentHasButton).toBe(false)
    })

    it('should display a link to the certificate if the certificate button URL ' +
      'has finished being generated', () => {
      const wrapper = shallowMount(CertificateButton, {
        propsData: {
          userScope: 'mentor',
        },
      })

      wrapper.vm.state = 'ready'

      const componentHasButton = wrapper.contains({
        ref: 'certificateButton'
      })

      expect(wrapper.contains(Icon)).toBe(false)
      expect(wrapper.contains('span')).toBe(false)
      expect(componentHasButton).toBe(true)
    })

    it('certificate link button should be a valid link', () => {
      const wrapper = shallowMount(CertificateButton, {
        propsData: {
          userScope: 'mentor',
        },
      })

      wrapper.vm.state = 'ready'

      const linkButton = wrapper
        .find('a.button')
        .element

      expect(linkButton.getAttribute('href')).toEqual('/mentor/certificates/')
      expect(linkButton.classList.contains('button')).toBe(true)
      expect(linkButton.text).toEqual('Open your certificate')
    })
  })

  describe('methods', () => {
    describe('createJob', () => {
      it('should set the state to "generating"', () => {
        const wrapper = shallowMount(CertificateButton, {
          propsData: {
            userScope: 'mentor',
          },
        })

        wrapper.vm.state = 'requesting'

        wrapper.vm.createJob()

        expect(wrapper.vm.state).toEqual('generating')
      })

      it('should send a POST request to the request endpoint', () => {
        const wrapper = shallowMount(CertificateButton, {
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
      it('should set the job id to that of the response', () => {
        const response = {
          jobId: 8,
        }

        const wrapper = shallowMount(CertificateButton, {
          propsData: {
            userScope: 'mentor',
          },
        })

        expect(wrapper.vm.jobId).toBeNull()

        wrapper.vm.handleJobRequest(response)

        expect(wrapper.vm.jobId).toEqual(response.jobId)
      })

      it('should not update the job id if the response does not contain ' +
        'a valid jobId', () => {
        const wrapper = shallowMount(CertificateButton, {
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

    it('pollJobQueue should send a GET request to the job monitor endpoint', () => {
      const wrapper = shallowMount(CertificateButton, {
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
      it('should poll the job status endpoint if the response status is "queued"', () => {
        const response = {
          status: 'queued',
        }

        const wrapper = shallowMount(CertificateButton, {
          propsData: {
            userScope: 'mentor',
          },
        })

        const pollJobQueueSpy = jest.spyOn(wrapper.vm, 'pollJobQueue')

        expect(pollJobQueueSpy).not.toHaveBeenCalled()

        wrapper.vm.handleGenerationRequest(response)

        expect(pollJobQueueSpy).toHaveBeenCalled()
      })

      it('should set the state to ready if the response status is "complete"', () => {
        const response = {
          status: 'complete',
        }

        const wrapper = shallowMount(CertificateButton, {
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

  it('should contain the proper state once all AJAX requests and job have finished', (done) => {
    const wrapper = shallowMount(CertificateButton, {
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