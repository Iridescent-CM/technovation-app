import { getRootRoute, getRootComponent } from 'student/routes'
import store from 'student/store'

describe("student/routes/index.js", () => {
  describe("#getRootRoute()", () => {
    it("returns 'scores' if the display_scores setting is enabled", () => {
      store.commit("authenticated/htmlDataset", {
        settings: '{"canDisplayScores": true}',
      })

      expect(getRootRoute()).toEqual({ name: "scores" })
    })

    it("does not returns 'scores' if the display_scores setting is disabled", () => {
      store.commit("authenticated/htmlDataset", {
        settings: '{"canDisplayScores": false}',
      })

      expect(getRootRoute()).not.toEqual({ name: "scores" })
    })

    it("returns parental consent if the student is not on a team or has no permission", () => {
      store.commit('authenticated/htmlDataset', {
        currentTeam:'{"data":{"id":"0","attributes":{}}}',
        parentalConsent:'{"data":{"id":"0","attributes":{}}}'
      })
      const route = getRootRoute()
      expect(route).toEqual({ name: "parental-consent" })
    })

    it("returns submission if the student is on a team and has permission", () => {
      store.commit('authenticated/htmlDataset', {
        currentTeam:'{"data":{"id":1,"attributes":{}}}',
        parentalConsent:'{"data":{"id":2,"attributes":{"isSigned":true}}}'
      })
      const route = getRootRoute()
      expect(route).toEqual({ name: "submission" })
    })
  })

  describe("#getRootComponent()", () => {
    it("returns 'scores' if the display_scores setting is enabled", () => {
      store.commit("authenticated/htmlDataset", {
        settings: '{"canDisplayScores": true}',
      })

      expect(getRootRoute()).toEqual({ name: "scores" })
    })

    it("does not returns 'scores' if the display_scores setting is disabled", () => {
      store.commit("authenticated/htmlDataset", {
        settings: '{"canDisplayScores": false}',
      })

      expect(getRootRoute()).not.toEqual({ name: "scores" })
    })

    it("returns TeamBuilding if the student is not on a team or has no permission", () => {
      store.commit('authenticated/htmlDataset', {
        currentTeam:'{"data":{"id":"0","attributes":{}}}',
        parentalConsent:'{"data":{"id":"0","attributes":{}}}'
      })
      const component = getRootComponent()
      expect(component.name).toEqual('team-building')
    })

    it("returns submission if the student is on a team and has permission", () => {
      store.commit('authenticated/htmlDataset', {
        currentTeam:'{"data":{"id":1,"attributes":{}}}',
        parentalConsent:'{"data":{"id":2,"attributes":{"isSigned":true}}}'
      })
      const component = getRootComponent()
      expect(component.name).toEqual('submission')
    })
  })
})
