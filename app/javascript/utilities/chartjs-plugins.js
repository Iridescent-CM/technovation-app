Chart.defaults.global.defaultFontFamily = 'sans-serif'

Chart.plugins.register({
  id: 'noDataToDisplay',
	afterDraw: (chart) => {
    const chartHasNonZeroData = chart.data.datasets[0].data.some((value) => {
      return value > 0
    })

  	if (!chartHasNonZeroData) {
    	// No data is present
      var ctx = chart.chart.ctx
      var width = chart.chart.width
      var height = chart.chart.height
      chart.clear()

      ctx.save()
      ctx.textAlign = 'center'
      ctx.textBaseline = 'middle'
      ctx.font = '16px sans-serif'
      ctx.fillStyle = '#999'
      ctx.fillText('No data to display', width / 2, height / 2)
      ctx.restore()
    }
  },
})

Chart.plugins.register({
  id: 'urlHandler',
  afterEvent: (chart, event) => {
    const chartElements = chart.getElementAtEvent(event)

    if (event.type === 'click' && chartElements.length) {
      const index = chartElements[0]._index
      const { urls } = chart.data.datasets[0]

      if (
        typeof index !== 'undefined'
        && typeof urls !== 'undefined'
        && urls.length > 0
      ) {
        window.location.href = urls[index]
      }
    }
  },
})
