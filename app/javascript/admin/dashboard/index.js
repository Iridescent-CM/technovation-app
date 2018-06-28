import Vue from 'vue/dist/vue.esm'
import VueRouter from 'vue-router'

import AdminDashboard from './components/AdminDashboard'
import PieChart from '../../components/PieChart'
import { router } from './routes'

Vue.use(VueRouter)

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

  const adminDashboardElement = document.getElementById('admin-dashboard')

  if (adminDashboardElement) {
    new Vue({
      router,
      el: '#admin-dashboard',
      render: h => h(AdminDashboard)
    })
  }
})
