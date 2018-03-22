import Vue from 'vue/dist/vue.esm'
import VueRouter from 'vue-router'

Vue.use(VueRouter)

import FinishedScoresList from './FinishedScoresList'

export const routes = [
  { path: '/', redirect: { name: 'finished-scores' } },
  {
    path: '/finished-scores',
    name: 'finished-scores',
    component: FinishedScoresList,
  },
]

export const router = new VueRouter({
  routes,
})
