import * as Utils from 'utilities/utilities'

describe('Helper Utilities', () => {

  describe('isEmptyObject', () => {

    it('returns true if object is empty', () => {
      const object = {}

      const result = Utils.isEmptyObject(object)

      expect(result).toBe(true)
    })

    it('returns false if the object is not empty', () => {
      const object = {
        key: 'value'
      }

      const result = Utils.isEmptyObject(object)

      expect(result).toBe(false)
    })

  })

})
