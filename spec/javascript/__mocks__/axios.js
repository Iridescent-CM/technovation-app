export default {
  mockRequest (method, returnData, options) {
    this[method].mockImplementation(() => {
      return Promise.resolve({
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