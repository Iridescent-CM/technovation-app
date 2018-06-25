import axios from 'axios'

describe('axios mock', () => {

  beforeEach(() => {
    axios.get.mockClear()
    axios.post.mockClear()
    axios.delete.mockClear()
  })

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
        expect(axios.post).toHaveBeenCalledWith('/test/url')
        expect(response).toEqual({ data: { some: 'value' } })
        done()
      })
    })

    it('mocks delete implementations with resolve by default', (done) => {
      axios.mockResponse('delete', { some: 'value' })

      axios.delete('/test/url').then((response) => {
        expect(axios.delete).toHaveBeenCalledWith('/test/url')
        expect(response).toEqual({ data: { some: 'value' } })
        done()
      })
    })

    it('mocks patch implementations with resolve by default', (done) => {
      axios.mockResponse('patch', { some: 'value' })

      axios.patch('/test/url').then((response) => {
        expect(axios.patch).toHaveBeenCalledWith('/test/url')
        expect(response).toEqual({ data: { some: 'value' } })
        done()
      })
    })

    it('mocks implementations with a reject by option', (done) => {
      axios.mockResponse('post', { rejected: 'value' }, { reject: true })

      axios.post('/test/url').catch((response) => {
        expect(axios.post).toHaveBeenCalledWith('/test/url')
        expect(response).toEqual({ data: { rejected: 'value' } })
        done()
      })
    })

    it('mocks implementations once with an option', (done) => {
      axios.mockResponse('post', { always: 'resolved' })
      axios.mockResponse('post', { resolved: 'once' }, { once: true })

      axios.post('/test/url').then((response) => {
        expect(axios.post).toHaveBeenCalledWith('/test/url')
        expect(response).toEqual({ data: { resolved: 'once' } })
      })

      axios.post('/test/url').then((response) => {
        expect(axios.post).toHaveBeenCalledWith('/test/url')
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

  describe('axios.mockResponseOnce', () => {
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