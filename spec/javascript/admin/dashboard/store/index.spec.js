import store, { state, getters, mutations } from 'admin/dashboard/store'

describe('Admin Dashboard - Vuex store', () => {

  beforeEach(() => {
    store.state.totals = {}
    store.state.chartEndpoints = {}
    store.state.cachedStates = {}
  })

  it('returns the initial state used by the AdminDashboard component', () => {
    expect(state).toEqual({
      chartEndpoints: {},
      cachedStates: {},
      totals: {},
    })
  })

  it('returns the getters used by the AdminDashboard component', () => {
    expect(getters).toEqual({
      getChartEndpoint: expect.any(Function),
      getCachedChartData: expect.any(Function),
      getTotalByName: expect.any(Function),
    })
  })

  it('returns the mutations used by the AdminDashboard component', () => {
    expect(mutations).toEqual({
      addChartEndpoints: expect.any(Function),
      addChartDataToCache: expect.any(Function),
      addTotals: expect.any(Function),
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

    describe('getTotalByName', () => {

      it('returns the total if it exists in the store', () => {
        store.state.totals = {
          students: 8436,
        }

        expect(store.getters.getTotalByName('students')).toEqual(8436)

        store.state.totals.students = 0

        expect(store.getters.getTotalByName('students')).toEqual(0)
      })

      it('returns null if the total does not exist in the store', () => {
        store.state.totals = {}

        expect(store.getters.getTotalByName('students')).toEqual(null)

        store.state.totals.students = null

        expect(store.getters.getTotalByName('students')).toEqual(null)
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

    describe('addTotals', () => {

      it('adds new chart totals by merging with the previous state data', () => {
        store.state.totals = {
          'chart_one': 1000,
          'chart_two': 2000,
        }

        store.commit('addTotals', {
          'chart_one': 8000,
          'chart_three': 3000,
        })

        expect(store.state.totals).toEqual({
          'chart_one': 8000,
          'chart_two': 2000,
          'chart_three': 3000,
        })
      })

    })

  })

})