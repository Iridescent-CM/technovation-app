import Vue from 'vue'
import VueRouter from 'vue-router'

import RegistrationApp from 'registration/App'
import TeamBuilding from 'mentor/components/TeamBuilding'
import Submission from 'mentor/components/Submission'
import Scores from 'mentor/components/Scores'
import Judging from 'mentor/components/Judging'

import store from '../store'

Vue.use(VueRouter)

import { routes as registrationRoutes } from 'registration/routes'
import teamRoutes from './teams'
import judgingRoutes from './judging'

const basicProfileRoute = registrationRoutes.find(
  route => route.name === 'basic-profile'
)

basicProfileRoute.props = {
  embedded: true,
}

const initApp = () => {
  const rootElem = document.getElementById('vue-data-registration')
  if (!rootElem) return false

  const { data: currentTeams } = JSON.parse(rootElem.dataset.currentTeams)
  const { data: { id: accountId, attributes: accountAttributes, relationships }} = JSON.parse(rootElem.dataset.currentAccount)
  const { data: { id: consentId, attributes: consentAttributes }} = JSON.parse(rootElem.dataset.consentWaiver)

  const currentAccount = Object.assign({ id: parseInt(accountId) }, store.state.registration, accountAttributes, relationships)
  const consentWaiver = Object.assign({ id: parseInt(consentId) }, store.state.mentor, consentAttributes)

  store.dispatch('registration/initAccount', currentAccount)
  store.dispatch('authenticated/initApp', { currentAccount, currentTeams, consentWaiver })
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

  if (anyCurrentTeams()) {
    return Submission
  } else {
    return TeamBuilding
  }
}

const getRootRoute = () => {
  if (anyCurrentTeams()) {
    return { name: 'submission' }
  } else {
    return { name: 'find-team' }
  }
}

const anyCurrentTeams = () => {
  if (!store.state.isReady) initApp()

  return store.state.mentor.currentTeams.length
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