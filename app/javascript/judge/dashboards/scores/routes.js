import Vue from 'vue/dist/vue.esm'
import VueRouter from 'vue-router'

import FinishedScoresList from './FinishedScoresList'
import AssignedScoresList from './AssignedScoresList'

export const dashboardAppRoutes = [
  { path: '/', redirect: { name: 'finished-scores' } },

  {
    path: '/finished-scores',
    name: 'finished-scores',
    component: FinishedScoresList,
  },

  {
    path: '/assigned-submissions',
    name: 'assigned-submissions',
    component: AssignedScoresList,
  },
]

export const dashboardAppRouter = new VueRouter({
  routes: dashboardAppRoutes,
})
