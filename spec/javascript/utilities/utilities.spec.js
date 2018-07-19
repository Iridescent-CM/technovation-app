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

  describe('debounce', () => {

    let booleanVariable
    let debouncedFunction

    beforeEach(() => {
      jest.useFakeTimers()
      booleanVariable = false
    })

    it('calls function after 500ms when no wait parameter is present', () => {
      debouncedFunction = Utils.debounce(() => {
        booleanVariable = true
      })

      expect(booleanVariable).toBe(false)

      debouncedFunction()

      jest.advanceTimersByTime(250)

      expect(booleanVariable).toBe(false)

      jest.advanceTimersByTime(251)

      expect(booleanVariable).toBe(true)
    })

    it('calls function after 1000ms when wait is set to 1000', () => {
      debouncedFunction = Utils.debounce(() => {
        booleanVariable = true
      }, 1000)

      expect(booleanVariable).toBe(false)

      debouncedFunction()

      jest.advanceTimersByTime(600)

      expect(booleanVariable).toBe(false)

      jest.advanceTimersByTime(401)

      expect(booleanVariable).toBe(true)
    })
  })

})
