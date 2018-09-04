import Vue from 'vue'

const TeamBuildingStep = Vue.component('team-building-step', {
  template: `<div><slot :name="$route.name">add App.vue and TeamBuilding.vue slots for route named {{ $route.name }}</slot></div>`,
})

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