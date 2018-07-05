import VueRouter from 'vue-router'

import Mentors from '../components/MentorsSection'
import Students from '../components/StudentsSection'
import Participants from '../components/ParticipantsSection'

export const routes = [
  { path: '/', redirect: { name: 'students' }},
  { path: '/students', name: 'students', component: Students },
  { path: '/mentors', name: 'mentors', component: Mentors },
  { path: '/participants', name: 'participants', component: Participants },
]

export const router = new VueRouter({
  routes,
})