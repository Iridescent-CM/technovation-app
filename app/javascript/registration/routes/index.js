import Vue from 'vue/dist/vue.esm'
import VueRouter from 'vue-router'

import DataUseTerms from '../components/DataUseTerms'
import EmailValidation from '../components/EmailValidation'
import PasswordValidation from '../components/PasswordValidation'
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
    path: '/email',
    name: 'email',
    component: EmailValidation,
  },
  {
    path: '/password',
    name: 'password',
    component: PasswordValidation,
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