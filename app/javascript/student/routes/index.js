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
    name: 'team',
    component: TeamBuilding,
    meta: {
      browserTitle: 'Part 2: Team building'
    },
    beforeEnter: initiateApp,
    children: teamRoutes,
  },
  {
    path: '/registration',
    name: 'registration',
    component: RegistrationApp,
    meta: {
      browserTitle: 'Part 1: Registration'
    },
    props: {
      removeWhiteBackground: false,
    },
    beforeEnter: initiateApp,
    children: registrationRoutes,
  },
  {
    path: '/submission',
    name: 'submission',
    component: Submission,
    meta: {
      browserTitle: 'Part 3: Submit your project'
    },
    beforeEnter: initiateApp,
  },
  {
    path: '/judging',
    name: 'judging',
    component: Judging,
    meta: {
      browserTitle: 'Part 4: Compete in the judging rounds'
    },
    beforeEnter: initiateApp,
    children: judgingRoutes,
  },
  {
    path: '/scores',
    name: 'scores',
    component: Scores,
    meta: {
      browserTitle: 'Part 5: Read scores & feedback'
    },
    beforeEnter: initiateApp,
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