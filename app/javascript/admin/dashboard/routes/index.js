import VueRouter from 'vue-router'

import Mentors from '../components/MentorsSection'
import Students from '../components/StudentsSection'
import TopCountries from '../components/TopCountriesSection'

export const routes = [
  { path: '/', redirect: { name: 'students' }},
  { path: '/students', name: 'students', component: Students },
  { path: '/mentors', name: 'mentors', component: Mentors },
  { path: '/top_countries', name: 'top_countries', component: TopCountries },
]

export const router = new VueRouter({
  routes,
})