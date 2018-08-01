import Vue from 'vue/dist/vue.esm'
import VueRouter from 'vue-router'

import store from '../store'

import DataUseTerms from '../components/DataUseTerms'

import AgeVerification from '../components/AgeVerification'
import BasicProfile from '../components/BasicProfile'

import Login from '../components/Login'
import Location from '../components/Location'

Vue.use(VueRouter)

const requireDataAgreement = (to, _from, next) => {
  if (!store.state.isReady) {
    const rootElem = document.getElementById('vue-enable-signup-wizard')
    const previousAttempt = rootElem.dataset.previousAttempt
    store.dispatch('initWizard', { previousAttempt })
  }

  if (to.matched.some(record => record.name !== 'data-use')) {
    if (!store.state.termsAgreed) {
      next({ name: 'data-use' })
    } else {
      next()
    }
  } else {
    next()
  }
}

export const routes = [
  { path: '/', redirect: { name: 'data-use' } },
  {
    path: '/data-use',
    name: 'data-use',
    component: DataUseTerms,
    beforeEnter: (_to, _from, next) => {
      if (!store.state.isReady) {
        const rootElem = document.getElementById('vue-enable-signup-wizard')
        const previousAttempt = rootElem.dataset.previousAttempt
        store.dispatch('initWizard', { previousAttempt })
        next()
      } else {
        next()
      }
    },
  },
  {
    path: '/age',
    name: 'age',
    component: AgeVerification,
    beforeEnter: requireDataAgreement,
  },
  {
    path: '/basic-profile',
    name: 'basic-profile',
    component: BasicProfile,
    beforeEnter: requireDataAgreement,
  },
  {
    path: '/login',
    name: 'login',
    component: Login,
    beforeEnter: requireDataAgreement,
  },
  {
    path: '/location',
    name: 'location',
    component: Location,
    beforeEnter: requireDataAgreement,
  },
]

export const router = new VueRouter({
  routes,
})

export default router