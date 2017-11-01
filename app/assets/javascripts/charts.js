var charts;
charts = function() {
  const $quickviewCharts = $(".quickview-charts");

  $quickviewCharts.each(function() {
    const $chartEl = $(this),
          ctx = $chartEl.get(0).getContext("2d"),
          data = $chartEl.data("chartData");

    var chart = new Chart(ctx, {
      type: 'pie',
      data: data,
      options: {
        legend: {
          position: 'bottom',
        },
        onClick: function(evt, els) {
          const urls = $chartEl.data("chartData").datasets[0].urls,
                i = els[0]._index;

          if (urls != undefined && urls.length > 0)
            window.location.href = urls[i];
        },
        onHover: function() {
          const urls = $chartEl.data("chartData").datasets[0].urls;

          if (urls != undefined && urls.length > 0)
            $chartEl.css({ cursor: "pointer" });
        },
      },
    });
  });
}

$(document).on("ready turbolinks:load", charts);
