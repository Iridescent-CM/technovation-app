import Vue from 'vue'
import VueRouter from 'vue-router'

import store from '../store'

import DataUseTerms from '../components/DataUseTerms'

import Location from '../components/Location'

import AgeVerification from '../components/AgeVerification'
import ChooseProfile from '../components/ChooseProfile'

import BasicProfile from '../components/BasicProfile'

import Login from '../components/Login'
import ChangeEmail from '../components/ChangeEmail'
import ChangePassword from '../components/ChangePassword'

Vue.use(VueRouter)

const initiateApp = () => {
  try {
    const rootElem = document.getElementById('vue-data-registration')
    const { data } = JSON.parse(rootElem.dataset.previousAttempt)
    const { attributes, relationships } = data

    if (data.type === 'account') {
      const currentAccount = Object.assign({}, store.state.registration, attributes, relationships)
      store.dispatch('registration/initAccount', currentAccount)
    } else {
      const previousAttempt = Object.assign({}, store.state.registration, attributes, relationships)
      store.dispatch('registration/initWizard', previousAttempt)
    }
  } catch (err) {
    console.error(err)
  }
}

const requireDataAgreement = (to, _from, next) => {
  if (!store.state.registration.isReady) initiateApp()

  const notDataUseComponent = to.matched.some(record => record.name !== 'data-use')

  if (notDataUseComponent && !store.state.registration.termsAgreed) {
    next({ name: 'data-use' })
  } else {
    next()
  }
}

const onLoginStep = () => {
  return !!store.getters.readyForAccount
}

const onChooseProfileStep = () => {
  return !!(store.state.registration.termsAgreed &&
            store.getters.isAgeSet &&
              !store.state.registration.profileChoice)
}

const onBasicProfileStep = () => {
  return !!(store.state.registration.termsAgreed &&
            store.getters.isAgeSet &&
              store.state.registration.profileChoice &&
                store.getters.isLocationSet)
}

const onLocationStep = () => {
  return !!(store.state.registration.termsAgreed &&
              store.getters.isAgeSet &&
                store.state.registration.profileChoice)
}

const onAgeStep = () => {
  return !!store.state.registration.termsAgreed
}

const getCurrentStep = () => {
  if (onLoginStep()) {
    return 'login'
  } else if (onBasicProfileStep()) {
    return 'basic-profile'
  } else if (onChooseProfileStep()) {
    return 'choose-profile'
  } else if (onAgeStep()) {
    return 'age'
  } else if (onLocationStep()) {
    return 'location'
  }

  return 'data-use'
}

export const routes = [
  {
    path: '/',
    beforeEnter: (_to, _from, next) => {
      if (!store.state.registration.isReady) initiateApp()
      next({ name: getCurrentStep() })
    },
  },
  {
    path: '/data-use',
    name: 'data-use',
    component: DataUseTerms,
    meta: {
      browserTitle: 'Step 1: Agreeement'
    },
    beforeEnter: (_to, _from, next) => {
      const store = require('../store').default
      if (!store.state.registration.isReady) initiateApp()
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
    beforeEnter: (_to, _from, next) => {
      requireDataAgreement(_to, _from, next)

      if (store.state.registration.isLocked) {
        next({ name: 'basic-profile' })
      } else {
        next()
      }
    },
  },
  {
    path: '/change-email',
    name: 'change-email',
    component: ChangeEmail,
    meta: {
      browserTitle: 'Change your Email'
    },
  },
  {
    path: '/change-password',
    name: 'change-password',
    component: ChangePassword,
    meta: {
      browserTitle: 'Change your Password'
    },
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