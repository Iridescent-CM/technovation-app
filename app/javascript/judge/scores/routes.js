import Vue from 'vue/dist/vue.esm';
import VueRouter from 'vue-router'

import ReviewSubmission from './ReviewSubmission'
import Ideation from "./Ideation"
import Technical from "./Technical"
import Pitch from "./Pitch"
import Entrepreneurship from "./Entrepreneurship"
import Overall from "./Overall"
import ReviewScore from './ReviewScore'

export const routes = [
  { path: '/', redirect: { name: 'review-submission' } },
  {
    path: '/review-submission',
    name: 'review-submission',
    component: ReviewSubmission,
  },
  { path: '/ideation', name: 'ideation', component: Ideation },
  { path: '/technical', name: 'technical', component: Technical },
  { path: '/pitch', name: 'pitch', component: Pitch },
  {
    path: '/entrepreneurship',
    name: 'entrepreneurship',
    component: Entrepreneurship,
  },
  { path: '/overall', name: 'overall', component: Overall },
  { path: '/review-score', name: 'review-score', component: ReviewScore },
]

export const router = new VueRouter({
  routes,
})
