import Vue from 'vue/dist/vue.esm'
import VueRouter from 'vue-router'

import AdminDashboard from './components/AdminDashboard'
import PieChart from '../../components/PieChart'

Vue.use(VueRouter)

import store from './store'
import { router } from './routes'

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
      store,
      el: adminDashboardElement,
      components: {
        AdminDashboard,
      },
    })
  }
})
