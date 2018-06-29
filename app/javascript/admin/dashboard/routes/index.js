import VueRouter from 'vue-router'

import Mentors from '../components/MentorsSection'
import Students from '../components/StudentSection'

export const routes = [
  { path: '/', redirect: { name: 'students' }},
  { path: '/students', name: 'students', component: Students, props: true },
  { path: '/mentors', name: 'mentors', component: Mentors, props: true }
]

export const router = new VueRouter({
  routes,
})