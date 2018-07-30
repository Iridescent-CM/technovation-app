import Vue from 'vue/dist/vue.esm'
import VueRouter from 'vue-router'

import DataUseTerms from '../components/DataUseTerms'

import AgeVerification from '../components/AgeVerification'
import GenderIdentity from '../components/GenderIdentity'

import Login from '../components/Login'
import LocationForm from '../../location/components/LocationForm'

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
    path: '/gender-identity',
    name: 'gender',
    component: GenderIdentity,
  },
  {
    path: '/login',
    name: 'login',
    component: Login,
  },
  {
    path: '/location',
    name: 'location',
    component: LocationForm,
    props: {
      scopeName: 'registration',
    },
  },
]

export const router = new VueRouter({
  routes,
})

export default router