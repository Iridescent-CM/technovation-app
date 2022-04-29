import VueRouter from 'vue-router'

import Overview from './sections/Overview'
import ProjectDetails from "./sections/ProjectDetails"
import Ideation from "./sections/Ideation"
import Pitch from "./sections/Pitch"
import Demo from "./sections/Demo"
import Entrepreneurship from "./sections/Entrepreneurship"
import ReviewScore from './sections/ReviewScore'

export const routes = [
  { path: '/', redirect: { name: 'overview' } },
  { path: '/overview', name: 'overview', component: Overview },
  { path: '/project-details', name: 'project_details', component: ProjectDetails },
  { path: '/ideation', name: 'ideation', component: Ideation },
  { path: '/pitch', name: 'pitch', component: Pitch },
  { path: '/demo', name: 'demo', component: Demo },
  { path: '/entrepreneurship', name: 'entrepreneurship', component: Entrepreneurship },
  { path: '/review-score', name: 'review-score', component: ReviewScore },
]

export const router = new VueRouter({
  routes,
})

router.afterEach(() => {
  document.getElementById('main-content').scrollIntoView();
})
