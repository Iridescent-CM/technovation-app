import Vue from 'vue/dist/vue.esm'
import PieChart from '../components/PieChart'

document.addEventListener('turbolinks:load', () => {
  const pieChartElements = document.querySelectorAll('.vue-enable-pie-chart')

  pieChartElements.forEach((element) => {
    new Vue({
      el: element,

      components: {
        PieChart,
      },
    })
  })
})
