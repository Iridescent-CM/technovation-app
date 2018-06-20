export default {
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