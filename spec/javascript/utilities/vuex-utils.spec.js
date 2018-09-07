import * as vuexUtils from 'utilities/vuex-utils'

describe("vuex-utils", () => {
  describe(".digStateData", () => {
    it("returns undefined for empty objects", () => {
      const state = {
        foo: {},
      }

      expect(vuexUtils.digStateData(state, 'foo')).toEqual(undefined)
    })

    it("returns the object's data", () => {
      const state = {
        foo: { data: { id: 1 } }
      }

      expect(vuexUtils.digStateData(state, 'foo', 'id')).toEqual(1)
    })
  })

  describe(".digStateAttributes", () => {
    it("returns undefined for empty objects", () => {
      const state = {
        foo: {},
      }

      expect(vuexUtils.digStateAttributes(state, 'foo', 'isSigned')).toEqual(undefined)
    })

    it("returns empty values", () => {
      const state = {
        foo: { data: { attributes: { bar: null } } },
      }

      expect(vuexUtils.digStateAttributes(state, 'foo', 'bar', bar => bar.baz)).toEqual(null)
    })

    it("accepts callbacks to check conditions", () => {
      const state = {
        foo: { data: { attributes: { bar: 0 } } },
      }

      expect(vuexUtils.digStateAttributes(state, 'foo', 'bar', bar => !!bar)).toEqual(false)
    })

    it("returns the object's data", () => {
      const state = {
        foo: { data: { attributes: { isSigned: false } } },
      }

      expect(vuexUtils.digStateAttributes(state, 'foo', 'isSigned')).toEqual(false)
    })
  })
})