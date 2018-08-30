import VueRouter from 'vue-router'

import ReviewSubmission from './sections/ReviewSubmission'
import Ideation from "./sections/Ideation"
import Technical from "./sections/Technical"
import Pitch from "./sections/Pitch"
import Entrepreneurship from "./sections/Entrepreneurship"
import Overall from "./sections/Overall"
import ReviewScore from './sections/ReviewScore'

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

  scrollBehavior (to, from, savedPosition) {
    if (savedPosition) {
      return savedPosition
    } else {
      return { x: 0, y: 0 }
    }
  }
})
