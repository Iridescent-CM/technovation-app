import axios from 'axios'

describe('axios mock', () => {
  describe('axios.mockResponse', () => {
    it('mocks get implementations with resolve by default', (done) => {
      axios.mockResponse('get', { myField: 'myValue' })

      axios.get('/test/url').then((response) => {
        expect(axios.get).toHaveBeenCalledWith('/test/url')
        expect(response).toEqual({ data: { myField: 'myValue' } })
        done()
      })
    })

    it('mocks post implementations with resolve by default', (done) => {
      axios.mockResponse('post', { some: 'value' })

      axios.post('/test/url').then((response) => {
        expect(axios.get).toHaveBeenCalledWith('/test/url')
        expect(response).toEqual({ data: { some: 'value' } })
        done()
      })
    })

    it('mocks implementations with a reject by option', (done) => {
      axios.mockResponse('post', { rejected: 'value' }, { reject: true })

      axios.post('/test/url').catch((response) => {
        expect(axios.get).toHaveBeenCalledWith('/test/url')
        expect(response).toEqual({ data: { rejected: 'value' } })
        done()
      })
    })

    it('mocks implementations once with an option', (done) => {
      axios.mockResponse('post', { always: 'resolved' })
      axios.mockResponse('post', { resolved: 'once' }, { once: true })

      axios.post('/test/url').then((response) => {
        expect(axios.get).toHaveBeenCalledWith('/test/url')
        expect(response).toEqual({ data: { resolved: 'once' } })
      })

      axios.post('/test/url').then((response) => {
        expect(axios.get).toHaveBeenCalledWith('/test/url')
        expect(response).toEqual({ data: { always: 'resolved' } })
        done()
      })
    })

    it('does not disturb normal boilerplate mocking', (done) => {
      axios.get.mockImplementation(() => {
        return Promise.resolve({ data: { status: 'complete' } })
      })

      axios.get('/test/url').then((response) => {
        expect(axios.get).toHaveBeenCalledWith('/test/url')
        expect(response).toEqual({ data: { status: 'complete' } })
        done()
      })
    })
  })

  describe('axios.mockResponse', () => {
    it('mocks responses once', (done) => {
      axios.mockResponse('get', { resolved: 'always' })
      axios.mockResponseOnce('get', { resolved: 'once' })

      axios.get('/test/url').then((response) => {
        expect(axios.get).toHaveBeenCalledWith('/test/url')
        expect(response).toEqual({ data: { resolved: 'once' } })
      })

      axios.get('/test/url').then((response) => {
        expect(axios.get).toHaveBeenCalledWith('/test/url')
        expect(response).toEqual({ data: { resolved: 'always' } })
        done()
      })
    })
  })
})