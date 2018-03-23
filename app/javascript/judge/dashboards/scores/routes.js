import Vue from 'vue/dist/vue.esm'
import VueRouter from 'vue-router'

import FinishedScoresList from './FinishedScoresList'

export const dashboardAppRoutes = [
  { path: '/', redirect: { name: 'finished-scores' } },
  {
    path: '/finished-scores',
    name: 'finished-scores',
    component: FinishedScoresList,
  },
]

export const dashboardAppRouter = new VueRouter({
  routes: dashboardAppRoutes,
})
