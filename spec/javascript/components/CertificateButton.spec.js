import { shallow } from '@vue/test-utils'

import axiosMock from 'axios'
import Icon from 'components/Icon'
import CertificateButton from 'components/CertificateButton'

describe('CertificateButton Vue component', () => {
  axiosMock.post.mockImplementation(() => {
    return Promise.resolve({
      data: { jobId: 5, test: 'blah' },
    })
  })
  axiosMock.get.mockImplementation(() => {
    return Promise.resolve({
      data: {
        status: 'complete',
        payload: {},
      },
    })
  })

  beforeEach(() => {
    axiosMock.post.mockClear()
    axiosMock.get.mockClear()
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
      axiosMock.post.mockImplementationOnce(() => {
        return Promise.resolve({
          data: {
            status: "complete",
            payload: {
              fileUrl: "some/test/url",
            },
          },
        })
      })

      const wrapper = shallow(CertificateButton, {
        propsData: {
          userScope: 'mentor',
        },
      })

      setImmediate(() => {
        const button = wrapper.find({ ref: 'certificateButton' })

        expect(wrapper.contains(Icon)).toBe(false)
        expect(wrapper.contains('span')).toBe(false)

        expect(button.exists()).toBe(true)
        expect(button.classes()).toContain('button')
        expect(button.attributes().href).toContain('some/test/url')
        expect(button.text()).toEqual('Open your certificate')

        done()
      });
    })
  })

  describe('methods', () => {
    describe('requestCertificate', () => {
      it('sets the state to "requesting"', () => {
        const wrapper = shallow(CertificateButton, {
          propsData: {
            userScope: 'mentor',
          },
        })

        wrapper.vm.state = ''

        wrapper.vm.requestCertificate()

        expect(wrapper.vm.state).toEqual('requesting')
      })

      it('sends a POST request to the request endpoint', () => {
        const wrapper = shallow(CertificateButton, {
          propsData: {
            userScope: 'mentor',
            teamId: 42892,
          },
        })

        axiosMock.post.mockClear()

        expect(axiosMock.post).not.toHaveBeenCalled()

        wrapper.vm.requestCertificate()

        expect(axiosMock.post).toHaveBeenCalledWith(
          '/mentor/certificates/',
          { team_id: 42892 },
        )
      })
    })

    describe('handleJobRequest', () => {
      it('sets the job id to that of the response', () => {
        const response = {
          data: {
            jobId: 8,
          },
        }

        const wrapper = shallow(CertificateButton, {
          propsData: {
            userScope: 'mentor',
          },
        })

        expect(wrapper.vm.jobId).toBeNull()

        wrapper.vm.handleJobRequest(response)

        expect(wrapper.vm.jobId).toEqual(8)
      })

      it('does not update the job id if the response does not contain ' +
          'a valid jobId', () => {
        const wrapper = shallow(CertificateButton, {
          propsData: {
            userScope: 'mentor',
          },
        })

        expect(wrapper.vm.jobId).toBeNull()

        wrapper.vm.handleJobRequest({ data: { jobId: 0 } })

        expect(wrapper.vm.jobId).toBeNull()

        wrapper.vm.handleJobRequest({ data: { noJobId: true } })

        expect(wrapper.vm.jobId).toBeNull()

        wrapper.vm.handleJobRequest({ data: { jobId: null } })

        expect(wrapper.vm.jobId).toBeNull()
      })

      it('sets the state to ready if the POST response status is "complete"', () => {
        const response = {
          data: {
            jobId: null,
            status: 'complete',
            payload: {
              fileUrl: "some/pdf"
            },
          },
        }

        const wrapper = shallow(CertificateButton, {
          propsData: {
            userScope: 'mentor',
          },
        })

        expect(wrapper.vm.state).toEqual('requesting')

        wrapper.vm.handleJobRequest(response)

        expect(wrapper.vm.state).toEqual('ready')
        expect(wrapper.vm.fileUrl).toEqual('some/pdf')
      })
    })

    describe('pollJobQueue', () => {
      it('sends a GET request to the job monitor endpoint', () => {
        const wrapper = shallow(CertificateButton, {
          propsData: {
            userScope: 'mentor',
          },
        })

        axiosMock.get.mockClear()

        expect(axiosMock.get).not.toHaveBeenCalled()

        wrapper.vm.jobId = 6

        wrapper.vm.pollJobQueue()

        expect(axiosMock.get).toHaveBeenCalledWith('/mentor/job_statuses/6')
      })

      it('returns early if the state is already ready', () => {
        const wrapper = shallow(CertificateButton, {
          propsData: {
            userScope: 'mentor',
          },
        })

        axiosMock.get.mockClear()

        expect(axiosMock.get).not.toHaveBeenCalled()

        wrapper.vm.state = 'ready'

        wrapper.vm.pollJobQueue()

        expect(axiosMock.get).not.toHaveBeenCalled()
      })
    })

    describe('handlePollRequest', () => {
      it('polls the job status endpoint if the response status is "queued"', () => {
        const response = {
          data: {
            status: 'queued',
            payload: {},
          },
        }

        const wrapper = shallow(CertificateButton, {
          propsData: {
            userScope: 'mentor',
          },
        })

        const pollJobQueueSpy = jest.spyOn(wrapper.vm, 'pollJobQueue')

        expect(pollJobQueueSpy).not.toHaveBeenCalled()

        wrapper.vm.handlePollRequest(response)

        expect(pollJobQueueSpy).toHaveBeenCalled()
      })

      it('sets the state to ready if the response status is "complete"', () => {
        const response = {
          data: {
            status: 'complete',
            payload: {},
          },
        }

        const wrapper = shallow(CertificateButton, {
          propsData: {
            userScope: 'mentor',
          },
        })

        expect(wrapper.vm.state).toEqual('requesting')

        wrapper.vm.handlePollRequest(response)

        expect(wrapper.vm.state).toEqual('ready')
      })

      it('sets the certificate fileUrl on status "complete"', () => {
        const response = {
          data: {
            status: 'complete',
            payload: {
              fileUrl: "my/url/dont/care"
            },
          },
        }

        const wrapper = shallow(CertificateButton, {
          propsData: {
            userScope: 'mentor',
          },
        })

        expect(wrapper.vm.state).toEqual('requesting')

        wrapper.vm.handlePollRequest(response)

        expect(wrapper.vm.fileUrl).toEqual('my/url/dont/care')
      })
    })
  })

  describe('computed property', () => {
    describe('certificateRequestData', () => {
      it('appends the team id if it is greater than 0', () => {
        const wrapper = shallow(CertificateButton, {
          propsData: {
            teamId: 9,
            userScope: 'mentor',
          },
        })

        expect(wrapper.vm.certificateRequestData).toEqual({
          team_id: 9,
        })
      })

      it('sends nothing if the teamId is 0 or null', () => {
        const wrapper = shallow(CertificateButton, {
          propsData: {
            userScope: 'mentor',
          },
        })

        expect(wrapper.vm.certificateRequestData).toEqual({})

        wrapper.teamId = null

        expect(wrapper.vm.certificateRequestData).toEqual({})
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