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

export const getRootComponent = () => {
  if (isOnTeam() && hasParentalConsent()) {
    return Submission
  } else {
    return TeamBuilding
  }
}

export const getRootRoute = () => {
  if (isOnTeam() && hasParentalConsent()) {
    return { name: 'submission' }
  } else {
    return { name: 'parental-consent' }
  }
}

const isOnTeam = () => {
  return store.getters['authenticated/isOnTeam']
}

const hasParentalConsent = () => {
  return store.getters['authenticated/hasParentalConsent']
}

export const routes = [
  {
    path: '/',
    component: getRootComponent(),
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
  {
    path: '*',
    redirect: '/',
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