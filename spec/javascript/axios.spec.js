import axios from 'axios'

describe('axios mock', () => {
  describe('axios.mockRequest', () => {
    it('mocks get implementations with resolve by default', (done) => {
      axios.mockRequest('get', { myField: 'myValue' })

      axios.get('/test/url').then((response) => {
        expect(axios.get).toHaveBeenCalledWith('/test/url')
        expect(response).toEqual({ data: { myField: 'myValue' } })
        done()
      })
    })

    it('mocks post implementations with resolve by default', (done) => {
      axios.mockRequest('post', { some: 'value' })

      axios.post('/test/url').then((response) => {
        expect(axios.get).toHaveBeenCalledWith('/test/url')
        expect(response).toEqual({ data: { some: 'value' } })
        done()
      })
    })

    it('mocks implementations with a reject by option', (done) => {
      axios.mockRequest('post', { rejected: 'value' }, { reject: true })

      axios.post('/test/url').catch((response) => {
        expect(axios.get).toHaveBeenCalledWith('/test/url')
        expect(response).toEqual({ data: { rejected: 'value' } })
        done()
      })
    })

    it('mocks implementations once with an option', (done) => {
      axios.mockRequest('post', { always: 'resolved' })
      axios.mockRequest('post', { resolved: 'once' }, { once: true })

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
})