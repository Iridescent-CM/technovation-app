import VueRouter from 'vue-router'

import FinishedScoresList from './FinishedScoresList'
import AssignedScoresList from './AssignedScoresList'
import QfScoresList from './QfScoresList'


export const routes = [
  { path: '/', redirect: { name: 'assigned-submissions' } },

  {
    path: '/finished-scores',
    name: 'finished-scores',
    component: FinishedScoresList,
  },

  {
    path: '/qf-scores',
    name: 'qf-scores',
    component: QfScoresList,
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
