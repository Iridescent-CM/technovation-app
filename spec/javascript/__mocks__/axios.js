export default {
  mockRequest (method, returnData, opts) {
    const options = Object.assign({}, opts)
    const promiseState = options.reject ? 'reject' : 'resolve'

    this[method].mockImplementation(() => {
      return Promise[promiseState]({
        data: returnData,
      })
    })
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
  })
};