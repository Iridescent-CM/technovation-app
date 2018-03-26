import Vue from 'vue/dist/vue.esm'
import VueRouter from 'vue-router'

import FinishedScoresList from './FinishedScoresList'
import AssignedScoresList from './AssignedScoresList'

export const routes = [
  { path: '/', redirect: { name: 'assigned-submissions' } },

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

export const router = new VueRouter({
  routes,
})
