import * as Utils from 'utilities/utilities'

describe('Helper Utilities', () => {
  beforeEach(() => {
    Utils.urlHelpers.getWindowSearch = () => {
      return '?back=%2Fstudent%2Fteam_submissions%2Fno-name-yet-by-all-star-team%3Fpiece%3Dsource_code' +
        '&team_id=11600' +
        '&bucket=technovation-uploads-dev' +
        '&key=direct_uploads%2F6a534b62-cb41-4686-875a-59d0200399ab%2Ftesting.zip' +
        '&etag=040215d1f4efa50e7571213bf1033f21'
    }
  })

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

  describe('urlHelpers', () => {
    describe('fetchGetParameters', () => {
      it('returns an array of objects with GET parameter key/value pairs', () => {
        const parameters = Utils.urlHelpers.fetchGetParameters()

        expect(parameters).toEqual([
          { back: '/student/team_submissions/no-name-yet-by-all-star-team?piece=source_code' },
          { team_id: '11600' },
          { bucket: 'technovation-uploads-dev' },
          { key: 'direct_uploads/6a534b62-cb41-4686-875a-59d0200399ab/testing.zip' },
          { etag: '040215d1f4efa50e7571213bf1033f21' },
        ])
      })
    })

    describe('fetchGetParameterValue', () => {
      it('returns the value for a passed GET parameter key', () => {
        const value = Utils.urlHelpers.fetchGetParameterValue('back')

        expect(value)
          .toEqual('/student/team_submissions/no-name-yet-by-all-star-team?piece=source_code')
      })
    })
  })
})
