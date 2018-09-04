import Vue from 'vue'

const TeamBuildingStep = Vue.component('team-building-step', {
  template: `<div><slot :name="$route.name">add App.vue and TeamBuilding.vue slots for route named {{ $route.name }}</slot></div>`,
})

export default [
  {
    path: '/bio',
    name: 'bio',
    component: TeamBuildingStep,
    meta: {
      browserTitle: "Fill out a summary"
    },
  },

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
    path: '/find-team',
    name: 'find-team',
    component: TeamBuildingStep,
    meta: {
      browserTitle: "Find and join an existing team"
    },
  },

  {
    path: '/create-team',
    name: 'create-team',
    component: TeamBuildingStep,
    meta: {
      browserTitle: "Create a new team"
    },
  },
]