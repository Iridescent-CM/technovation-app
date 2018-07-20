import Vue from 'vue/dist/vue.esm'
import VueRouter from 'vue-router'

import EmailValidation from '../components/EmailValidation'
import PasswordValidation from '../components/PasswordValidation'
import LocationForm from '../../location/components/LocationForm'

Vue.use(VueRouter)

export const routes = [
  { path: '/', redirect: { name: 'email-validation' } },
  {
    path: '/email',
    name: 'email-validation',
    component: EmailValidation,
  },
  {
    path: '/password',
    name: 'password-validation',
    component: PasswordValidation,
  },
  {
    path: '/location',
    name: 'location',
    component: LocationForm,
  },
]

export const router = new VueRouter({
  routes,
})

export default router