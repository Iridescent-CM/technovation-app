import Vue from 'vue'
import store from 'mentor/store'

const TeamBuildingStep = Vue.component('team-building-step', {
  template: `<div><slot :name="$route.name">add App.vue and TeamBuilding.vue slots for route named {{ $route.name }}</slot></div>`,
})

const mustBeOnboarded = (_to, from, next) => {
  if (store.getters['authenticated/isOnboarded']) {
    next()
  } else {
    next(from)
  }
}

export default [
  {
    path: '/consent-waiver',
    name: 'consent-waiver',
    component: TeamBuildingStep,
    meta: {
      browserTitle: "Sign the volunteer consent waiver"
    },
  },

  {
    path: '/background-check',
    name: 'background-check',
    component: TeamBuildingStep,
    meta: {
      browserTitle: "Background check"
    },
  },

  {
    path: '/bio',
    name: 'bio',
    component: TeamBuildingStep,
    meta: {
      browserTitle: "Fill out a summary"
    },
  },

  {
    path: '/find-team',
    name: 'find-team',
    component: TeamBuildingStep,
    beforeEnter: mustBeOnboarded,
    meta: {
      browserTitle: "Find and join an existing team"
    },
  },

  {
    path: '/create-team',
    name: 'create-team',
    component: TeamBuildingStep,
    beforeEnter: mustBeOnboarded,
    meta: {
      browserTitle: "Create a new team"
    },
  },
]