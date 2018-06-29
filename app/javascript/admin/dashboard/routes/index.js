import VueRouter from 'vue-router'

import Mentors from '../components/MentorsSection'
import Students from '../components/StudentsSection'

export const routes = [
  { path: '/', redirect: { name: 'students' }},
  { path: '/students', name: 'students', component: Students },
  { path: '/mentors', name: 'mentors', component: Mentors }
]

export const router = new VueRouter({
  routes,
})