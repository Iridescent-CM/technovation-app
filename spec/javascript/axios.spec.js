import axios from 'axios'

describe('axios mock', () => {
  describe('axios.mockRequest', () => {
    it('mocks implementations with resolve by default', (done) => {
      axios.mockRequest('get', {
        myField: 'myValue',
      })

      axios.get('/test/url').then((response) => {
        expect(axios.get).toHaveBeenCalledWith('/test/url')
        expect(response).toEqual({ data: { myField: 'myValue' } })
        done()
      })
    })

    xit('returns the proper mock for POST', (done) => {
      axios.post('/this/is/a/test/url').then((response) => {
        expect(axios.post).toHaveBeenCalledWith('/this/is/a/test/url')
        expect(response).toEqual({ data: {} })
        done()
      })
    })
  })
})