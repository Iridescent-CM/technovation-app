import Vue from 'vue/dist/vue.esm'
import VueRouter from 'vue-router'

import store from '../store'

import DataUseTerms from '../components/DataUseTerms'

import AgeVerification from '../components/AgeVerification'
import BasicProfile from '../components/BasicProfile'

import Login from '../components/Login'
import Location from '../components/Location'

Vue.use(VueRouter)

const initiateApp = () => {
  try {
    const rootElem = document.getElementById('vue-enable-signup-wizard')
    const { data: { attributes }} = JSON.parse(rootElem.dataset.previousAttempt)
    const previousAttempt = Object.assign({}, store.state, attributes)

    store.dispatch('initWizard', previousAttempt)
  } catch (err) {
    console.error(err)
  }
}

const requireDataAgreement = (to, _from, next) => {
  if (!store.state.isReady) initiateApp()

  const notDataUseComponent = to.matched.some(record => record.name !== 'data-use')

  if (notDataUseComponent && !store.state.termsAgreed) {
    next({ name: 'data-use' })
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
      if (!store.state.isReady) initiateApp()
      next()
    },
  },
  {
    path: '/age',
    name: 'age',
    component: AgeVerification,
    beforeEnter: requireDataAgreement,
  },
  {
    path: '/location',
    name: 'location',
    component: Location,
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
]

export const router = new VueRouter({
  routes,
})

export default router