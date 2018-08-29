import mutations from 'registration/store/mutations'

describe("Registration::Store::Mutations", () => {
  describe(".basicProfile", () => {
    it("updates the state's referredByOther", () => {
      let state = {
        referredByOther: null,
        expertiseIds: [],
      }

      mutations.basicProfile(state, { referredByOther: 'not null' })

      expect(state.referredByOther).toEqual('not null')
    })
  })
})