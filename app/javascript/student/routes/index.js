import Vue from 'vue'
import VueRouter from 'vue-router'

import RegistrationApp from 'registration/App'
import TeamBuilding from 'student/components/TeamBuilding'
import Submission from 'dashboard/components/Submission'
import Scores from 'dashboard/components/Scores'
import Events from 'dashboard/components/Events'

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
  if (canDisplayScores()) {
    return Scores
  } else if (isOnTeam() && hasParentalConsent()) {
    return Submission
  } else {
    return TeamBuilding
  }
}

export const getRootRoute = () => {
  if (canDisplayScores()) {
    return { name: 'scores' }
  } else if (isOnTeam() && hasParentalConsent()) {
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

const canDisplayScores = () => {
  return store.getters['authenticated/canDisplayScores']
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
      browserTitle: 'Build your Team',
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
      browserTitle: 'Registration',
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
      browserTitle: 'Submit your Project',
    },
  },
  {
    path: '/events',
    name: 'events',
    component: Events,
    beforeEnter: loadOrRedirect,
    meta: {
      routeId: 'events',
      browserTitle: 'Find a Pitch Event',
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
      browserTitle: 'View Scores & Feedback',
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
