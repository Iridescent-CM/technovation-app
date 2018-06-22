export default {
  mockResponse (method, returnData, opts) {
    const options = Object.assign({}, opts)

    const promiseState = options.reject ? 'reject' : 'resolve'

    const mockImplementationFunc = options.once ?
      'mockImplementationOnce' : 'mockImplementation'

    this[method][mockImplementationFunc](() => {
      return Promise[promiseState]({
        data: returnData,
      })
    })
  },

  mockResponseOnce (method, returnData, opts) {
    const options = Object.assign({}, opts, { once: true })
    this.mockResponse(method, returnData, options)
  },

  get: jest.fn((url) => {
    return Promise.resolve({
      data: {}
    })
  }),

  post: jest.fn((url) => {
    return Promise.resolve({
      data: {}
    })
  }),

  delete: jest.fn((url) => {
    return Promise.resolve({
      data: {}
    })
  }),
};