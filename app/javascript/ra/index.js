import Vue from 'vue/dist/vue.esm'
import PieChart from '../components/PieChart'

document.addEventListener('turbolinks:load', () => {
  const btnEls = document.querySelectorAll('.vue-enable-pie-chart')

  btnEls.forEach((btnEl) => {
    new Vue({
      el: btnEl,

      components: {
        PieChart,
      },
    })
  })
})
