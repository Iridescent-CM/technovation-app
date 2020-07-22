import Vue from 'vue'
import VueRouter from 'vue-router'

import AdminDashboard from './components/AdminDashboard'
import StudentsSection from './components/StudentsSection'
import MentorsSection from './components/MentorsSection'
import PieChart from '@appjs/components/PieChart'

Vue.use(VueRouter)

import store from './store'
import { router } from './routes'

document.addEventListener('turbolinks:load', () => {
  const pieChartElements = document.querySelectorAll('.vue-enable-pie-chart')

  if (pieChartElements.length) {
    for (let i = 0; i < pieChartElements.length; i += 1) {
      new Vue({
        el: pieChartElements[i],

        components: {
          PieChart,
        },
      })
    }
  }

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
   * Chapter Ambassador Dashboards
   */
  const studentsSectionElement = document.getElementById('chapter-ambassador-admin-students-section')

  if (studentsSectionElement) {
    new Vue({
      store,
      el: studentsSectionElement,
      components: {
        StudentsSection,
      },
    })
  }

  const mentorsSectionElement = document.getElementById('chapter-ambassador-admin-mentors-section')

  if (mentorsSectionElement) {
    new Vue({
      store,
      el: mentorsSectionElement,
      components: {
        MentorsSection,
      },
    })
  }
})
