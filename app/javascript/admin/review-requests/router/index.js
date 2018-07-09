import VueRouter from 'vue-router'

import Pending from '../components/Pending'
import Approved from '../components/Approved'
import Declined from '../components/Declined'

export const routes = [
  { path: '/', redirect: { name: 'pending' }},
  { path: '/pending', name: 'pending', component: Pending },
  { path: '/approved', name: 'approved', component: Approved },
  { path: '/declined', name: 'declined', component: Declined },
]

export default new VueRouter({
  routes,
})