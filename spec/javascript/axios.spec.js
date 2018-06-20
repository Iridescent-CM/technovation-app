import axios from 'axios'

describe('axios mock', () => {
  it('returns the proper mock for GET', (done) => {
    axios.get('/this/is/a/test/url').then((response) => {
      expect(axios.get).toHaveBeenCalledWith('/this/is/a/test/url')
      expect(response).toEqual({ data: {} })
      done()
    })
  })

  it('returns the proper mock for POST', (done) => {
    axios.post('/this/is/a/test/url').then((response) => {
      expect(axios.post).toHaveBeenCalledWith('/this/is/a/test/url')
      expect(response).toEqual({ data: {} })
      done()
    })
  })
})