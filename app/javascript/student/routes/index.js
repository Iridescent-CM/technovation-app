import Vue from 'vue'
import VueRouter from 'vue-router'

import RegistrationApp from 'registration/App'
import TeamBuilding from 'student/components/TeamBuilding'
import Submission from 'student/components/Submission'
import Scores from 'student/components/Scores'
import Judging from 'student/components/Judging'

import store from '../store'

Vue.use(VueRouter)

import { routes as registrationRoutes } from 'registration/routes'
import teamRoutes from './teams'
import judgingRoutes from './judging'

const initApp = () => {
  const rootElem = document.getElementById('vue-data-registration')
  if (!rootElem) return false

  const { data: { id: teamId, attributes: teamAttributes }} = JSON.parse(rootElem.dataset.currentTeam)
  const { data: { id: accountId, attributes: accountAttributes, relationships }} = JSON.parse(rootElem.dataset.currentAccount)
  const { data: { id: parentalConsentId, attributes: parentalConsentAttributes }} = JSON.parse(rootElem.dataset.parentalConsent)

  const currentAccount = Object.assign({ id: parseInt(accountId) }, store.state.registration, accountAttributes, relationships)
  const currentTeam = Object.assign({ id: parseInt(teamId) }, teamAttributes)
  const parentalConsent = Object.assign({ id: parseInt(parentalConsentId) }, parentalConsentAttributes)

  store.dispatch('registration/initAccount', currentAccount)
  store.dispatch('student/initApp', { currentAccount, currentTeam, parentalConsent })
}

const initiateApp = (to, from, next) => {
  try {
    initApp()

    if (to.path === '/' && from.path === '/') {
      next(getRootRoute())
    } else {
      next()
    }
  } catch (err) {
    console.error(err)
    next()
  }
}

const getRootComponent = () => {
  if (!store.state.isReady) initApp()

  if (getCurrentTeamId()) {
    return Submission
  } else {
    return TeamBuilding
  }
}

const getRootRoute = () => {
  if (getCurrentTeamId()) {
    return { name: 'submission' }
  } else {
    return { name: 'parental-consent' }
  }
}

const getCurrentTeamId = () => {
  if (!store.state.isReady) initApp()
  return store.state.student.currentTeam.id
}

export const routes = [
  {
    path: '/',
    component: getRootComponent(),
    beforeEnter: initiateApp,
  },
  {
    path: '/team',
    component: TeamBuilding,
    props: {
      stickySidebarClasses: ['grid__col-3'],
      embedded: true,
    },
    beforeEnter: initiateApp,
    children: teamRoutes,
    meta: {
      routeId: 'team',
      browserTitle: 'Part 2: Team building',
    },
  },
  {
    path: '/registration',
    component: RegistrationApp,
    props: {
      removeWhiteBackground: false,
      stickySidebarClasses: ['grid__col-3'],
      embedded: true,
    },
    beforeEnter: initiateApp,
    children: registrationRoutes,
    meta: {
      routeId: 'registration',
      browserTitle: 'Part 1: Registration',
    },
  },
  {
    path: '/submission',
    name: 'submission',
    component: Submission,
    props: {
      stickySidebarClasses: ['grid__col-3'],
    },
    beforeEnter: initiateApp,
    meta: {
      routeId: 'submission',
      browserTitle: 'Part 3: Submit your project',
    },
  },
  {
    path: '/judging',
    name: 'judging',
    component: Judging,
    props: {
      stickySidebarClasses: ['grid__col-3'],
      embedded: true,
    },
    beforeEnter: initiateApp,
    children: judgingRoutes,
    meta: {
      routeId: 'judging',
      browserTitle: 'Part 4: Compete in the judging rounds',
    },
  },
  {
    path: '/scores',
    name: 'scores',
    component: Scores,
    props: {
      stickySidebarClasses: ['grid__col-3'],
    },
    beforeEnter: initiateApp,
    meta: {
      routeId: 'scores',
      browserTitle: 'Part 5: Read scores & feedback',
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