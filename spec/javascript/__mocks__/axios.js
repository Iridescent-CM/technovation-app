const mockedAxios = {
  mockResponse (method, returnData, opts) {
    const options = Object.assign({ status: 200 }, opts)

    const promiseState = options.reject ? 'reject' : 'resolve'

    const mockImplementationFunc = options.once ?
      'mockImplementationOnce' : 'mockImplementation'

    this[method][mockImplementationFunc](() => {
      return Promise[promiseState]({
        data: returnData,
        status: options.status
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

  patch: jest.fn((url) => {
    return Promise.resolve({
      data: {}
    })
  }),
}

if (!global.window) {
  global.window = {
    axios: mockedAxios,
  }
} else {
  global.window.axios = mockedAxios
}

export default mockedAxios