import Vue from 'vue'
import Vuex from 'vuex'

import state from 'admin/dashboard/store/state'
import getters from 'admin/dashboard/store/getters'
import mutations from 'admin/dashboard/store/mutations'

Vue.use(Vuex)

describe('Admin Dashboard - Vuex store', () => {

  let store

  beforeEach(() => {
    const actions = {}

    store = new Vuex.Store({
      state,
      getters,
      mutations,
      actions,
    })
  })

  it('returns the initial state used by the AdminDashboard component', () => {
    expect(state).toEqual({
      chartEndpoints: {},
      cachedStates: {},
    })
  })

  it('returns the getters used by the AdminDashboard component', () => {
    expect(getters).toEqual({
      getChartEndpoint: expect.any(Function),
      getCachedChartData: expect.any(Function),
    })
  })

  it('returns the mutations used by the AdminDashboard component', () => {
    expect(mutations).toEqual({
      addChartEndpoints: expect.any(Function),
      addChartDataToCache: expect.any(Function),
    })
  })

  describe('getters', () => {

    describe('getChartEndpoint', () => {

      it('returns the url endpoint if it exists in the store', () => {
        store.state.chartEndpoints = {
          'chart_one': '/chart/one/',
        }

        expect(store.getters.getChartEndpoint('chart_one'))
          .toEqual('/chart/one/')
      })

      it('returns a blank string if it does not exist in the store', () => {
        store.state.chartEndpoints = {}

        expect(store.getters.getChartEndpoint('chart_one'))
          .toEqual('')
      })

    })

    describe('getCachedChartData', () => {

      it('returns the cached state for the given endpoint if it exists in the store', () => {
        const cachedStateForChartOne = {
          labels: [ 'One', 'Two' ],
          data: [ 1, 3 ],
          urls: [ '/one/', '/two/' ],
        }

        store.state.chartEndpoints = {
          'chart_one': '/chart/one/',
        }

        store.state.cachedStates = {
          '/chart/one/': cachedStateForChartOne,
        }

        expect(store.getters.getCachedChartData('chart_one'))
          .toEqual(cachedStateForChartOne)
      })

      it('returns an empty object for the given endpoint if it ' +
        'does not exist in the store', () => {
          store.state.chartEndpoints = {}
          store.state.cachedStates = {}

          expect(store.getters.getCachedChartData('chart_one'))
            .toEqual({})

          store.state.chartEndpoints = {
            'chart_one': '/chart/one/',
          }

          store.state.cachedStates = {}

          expect(store.getters.getCachedChartData('chart_one'))
            .toEqual({})
      })

    })

  })

  describe('mutations', () => {

    describe('addChartEndpoints', () => {

      it('adds new chart endpoints by merging with the previous state data', () => {
        store.state.chartEndpoints = {
          'chart_one': '/chart/one/original/',
          'chart_two': '/chart/two/original/',
        }

        store.commit('addChartEndpoints', {
          'chart_one': '/chart/one/overwritten/',
          'chart_three': '/chart/three/original/',
        })

        expect(store.state.chartEndpoints).toEqual({
          'chart_one': '/chart/one/overwritten/',
          'chart_two': '/chart/two/original/',
          'chart_three': '/chart/three/original/',
        })
      })

    })

    describe('addChartDataToCache', () => {

      it('adds the chart data to the store for the given payload url', () => {
        const chartData = {
          labels: [ 'One', 'Two' ],
          data: [ 1, 3 ],
          urls: [ '/one/', '/two/' ],
        }

        store.state.cachedStates = {
          '/some/url': {
            labels: [
              'A label'
            ],
            data: [
              999,
            ],
          },
        }

        store.commit('addChartDataToCache', {
          chartData,
          url: '/some/url',
        })

        expect(store.state.cachedStates).toEqual({
          '/some/url': chartData,
        })
      })

    })

  })

})