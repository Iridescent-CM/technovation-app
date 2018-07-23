import VueRouter from 'vue-router'

import Events from '../components/Events'
import Judging from '../components/Judging'
import Notices from '../components/Notices'
import Registration from '../components/Registration'
import ScoresAndCertificates from '../components/ScoresAndCertificates'
import Surveys from '../components/Surveys'
import TeamsAndSubmissions from '../components/TeamsAndSubmissions'

export const routes = [
  {
    path: '/',
    redirect: {
      name: 'registration',
    },
  },
  {
    path: '/events',
    name: 'events',
    component: Events,
  },
  {
    path: '/judging',
    name: 'judging',
    component: Judging,
  },
  {
    path: '/notices',
    name: 'notices',
    component: Notices,
  },
  {
    path: '/registration',
    name: 'registration',
    component: Registration,
  },
  {
    path: '/scores_and_certificates',
    name: 'scores_and_certificates',
    component: ScoresAndCertificates,
  },
  {
    path: '/surveys',
    name: 'surveys',
    component: Surveys,
  },
  {
    path: '/teams_and_submissions',
    name: 'teams_and_submissions',
    component: TeamsAndSubmissions,
  },
]

export const router = new VueRouter({
  routes,
})