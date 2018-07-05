import Vue from 'vue/dist/vue.esm'
import VueRouter from 'vue-router'

import AdminDashboard from './components/AdminDashboard'
import StudentsSection from './components/StudentsSection'
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

  /**
   * Admin Dashboards
   */
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

  /**
   * Regional Ambassador Dashboards
   */
  const studentsSectionElement = document.getElementById('ra-admin-students-section')

  if (studentsSectionElement) {
    new Vue({
      store,
      el: studentsSectionElement,
      components: {
        StudentsSection,
      },
    })
  }
})
