import mutations from 'mentor/store/mutations'

describe('Mentor store - mutations', () => {
  describe('location', () => {
    it('sets the authenticated module state location data', () => {
      const state = {
        currentAccount: {
          data: {
            attributes: {
              city: 'Calgary',
              country: 'Canada',
              countryCode: 'CA',
              state: 'Alberta',
              stateCode: 'AB',
            },
          },
        },
      }

      mutations.location(state, {
        city: 'Kansas City',
        country: 'United States',
        state: 'Missouri',
      })

      expect(state.currentAccount.data.attributes).toEqual({
        city: 'Kansas City',
        country: 'United States',
        countryCode: null,
        state: 'Missouri',
        stateCode: null,
      })
    })
  })
})