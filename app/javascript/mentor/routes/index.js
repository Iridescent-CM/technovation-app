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

const loadOrRedirect = (to, from, next) => {
  try {
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
  if (anyCurrentTeams()) {
    return Submission
  } else {
    return TeamBuilding
  }
}

const getRootRoute = () => {
  if (anyCurrentTeams()) {
    return { name: 'submission' }
  }

  if (isOnboarded())  {
    return { name: 'find-team' }
  }

  return { name: store.getters['authenticated/nextOnboardingStep'] }
}

const anyCurrentTeams = () => {
  return store.state.authenticated.currentTeams.length
}

const isOnboarded = () => {
  return store.getters['authenticated/isOnboarded']
}

export const routes = [
  {
    path: '/',
    component: getRootComponent(),
    props: {
      embedded: true,
    },
    beforeEnter: loadOrRedirect,
  },
  {
    path: '/team',
    component: TeamBuilding,
    props: {
      stickySidebarClasses: ['grid__col-3'],
      embedded: true,
    },
    beforeEnter: loadOrRedirect,
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
    beforeEnter: loadOrRedirect,
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
    beforeEnter: loadOrRedirect,
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
    beforeEnter: loadOrRedirect,
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
    beforeEnter: loadOrRedirect,
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