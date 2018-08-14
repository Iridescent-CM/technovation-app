import Vue from 'vue/dist/vue.esm'
import VueRouter from 'vue-router'

import store from '../store'

import DataUseTerms from '../components/DataUseTerms'

import Location from '../components/Location'

import AgeVerification from '../components/AgeVerification'
import ChooseProfile from '../components/ChooseProfile'

import BasicProfile from '../components/BasicProfile'

import Login from '../components/Login'

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
    meta: {
      browserTitle: 'Step 1: Agreeement'
    },
    beforeEnter: (_to, _from, next) => {
      if (!store.state.isReady) initiateApp()
      next()
    },
  },
  {
    path: '/age',
    name: 'age',
    component: AgeVerification,
    meta: {
      browserTitle: 'Step 3: Age'
    },
    beforeEnter: requireDataAgreement,
  },
  {
    path: '/region',
    name: 'location',
    component: Location,
    meta: {
      browserTitle: 'Step 2: Region'
    },
    beforeEnter: requireDataAgreement,
  },
  {
    path: '/choose-profile',
    name: 'choose-profile',
    component: ChooseProfile,
    meta: {
      browserTitle: 'Step 4: Choose your profile'
    },
    beforeEnter: requireDataAgreement,
  },
  {
    path: '/basic-profile',
    name: 'basic-profile',
    component: BasicProfile,
    meta: {
      browserTitle: 'Step 5: Basic Profile'
    },
    beforeEnter: requireDataAgreement,
  },
  {
    path: '/signin',
    name: 'login',
    component: Login,
    meta: {
      browserTitle: 'Final step: Sign In'
    },
    beforeEnter: requireDataAgreement,
  },
]

export const router = new VueRouter({
  routes,
})

router.afterEach((to, _from) => {
  if(window && window.document)
    window.document.title = to.meta.browserTitle + " • Technovation"
})

export default router