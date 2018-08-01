import getters from 'registration/store/getters'

describe("Registration::Store::Getters", () => {
  describe(".getReferredByOther", () => {
    it("returns the state's referredByOther", () => {
      const state = {
        referredByOther: 'hello world',
      }

      const result = getters.getReferredByOther(state)

      expect(result).toEqual('hello world')
    })
  })
})