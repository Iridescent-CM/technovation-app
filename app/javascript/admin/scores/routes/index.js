import Vue from 'vue/dist/vue.esm';
import VueRouter from 'vue-router'

import SuspiciousScoresList from '../suspicious_scores/list'

export const routes = [
  { path: '/', component: SuspiciousScoresList },
]

export const router = new VueRouter({
  routes,
})
