import Vue from 'vue/dist/vue.esm'
import VueRouter from 'vue-router'

import DataUseTerms from '../components/DataUseTerms'

import AgeVerification from '../components/AgeVerification'
import BasicProfile from '../components/BasicProfile'

import Login from '../components/Login'
import Location from '../components/Location'

Vue.use(VueRouter)

export const routes = [
  { path: '/', redirect: { name: 'data-use' } },
  {
    path: '/data-use',
    name: 'data-use',
    component: DataUseTerms,
  },
  {
    path: '/age',
    name: 'age',
    component: AgeVerification,
  },
  {
    path: '/basic-profile',
    name: 'basic-profile',
    component: BasicProfile,
  },
  {
    path: '/login',
    name: 'login',
    component: Login,
  },
  {
    path: '/location',
    name: 'location',
    component: Location,
  },
]

export const router = new VueRouter({
  routes,
})

export default router