import Vue from 'vue/dist/vue.esm'
import VueRouter from 'vue-router'

import RegistrationApp from 'registration/App'
import TeamBuilding from 'student/components/TeamBuilding'

import store from '../store'

Vue.use(VueRouter)

import { routes as registrationRoutes } from 'registration/routes'
import teamRoutes from './teams'

const initiateApp = (_to, _from, next) => {
  try {
    const rootElem = document.getElementById('vue-data-registration')
    const { data: { attributes, relationships }} = JSON.parse(rootElem.dataset.currentAccount)
    const currentAccount = Object.assign({}, store.state, attributes, relationships)

    store.dispatch('initApp', { currentAccount })
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
    component: RegistrationApp,
    meta: {
      browserTitle: 'Part 1: Registration'
    },
    beforeEnter: initiateApp,
    children: registrationRoutes,
  },
  {
    path: '/submission',
    name: 'submission',
    component: TeamBuilding,
    meta: {
      browserTitle: 'Part 3: Submit your project'
    },
    beforeEnter: initiateApp,
  },
  {
    path: '/judging',
    name: 'judging',
    component: TeamBuilding,
    meta: {
      browserTitle: 'Part 4: Compete in the judging rounds'
    },
    beforeEnter: initiateApp,
  },
  {
    path: '/scores',
    name: 'scores',
    component: TeamBuilding,
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