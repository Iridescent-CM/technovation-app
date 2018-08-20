import Vue from 'vue/dist/vue.esm'
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

const initiateApp = (_to, _from, next) => {
  try {
    const rootElem = document.getElementById('vue-data-registration')
    const { data: { attributes, relationships }} = JSON.parse(rootElem.dataset.currentAccount)
    const currentAccount = Object.assign({}, store.state.registration, attributes, relationships)

    store.dispatch('student/initApp', { currentAccount })
    next()
  } catch (err) {
    console.error(err)
    next()
  }
}

export const routes = [
  {
    path: '/',
    component: TeamBuilding
  },
  {
    path: '/team',
    component: TeamBuilding,
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