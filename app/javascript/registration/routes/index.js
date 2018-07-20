import Vue from 'vue/dist/vue.esm'
import VueRouter from 'vue-router'

import EmailValidation from '../components/EmailValidation'
import PasswordValidation from '../components/PasswordValidation'

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
]

export const router = new VueRouter({
  routes,
})

export default router