import Vue from 'vue'

const TeamBuildingStep = Vue.component('team-building-step', {
  template: `<div><slot :name="$route.name">add App.vue and TeamBuilding.vue slots for route named {{ $route.name }}</slot></div>`,
})

export default [
  {
    path: '/parental-consent',
    name: 'parental-consent',
    component: TeamBuildingStep,
    meta: {
      browserTitle: "Parental consent"
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

  {
    path: '/find-mentor',
    name: 'find-mentor',
    component: TeamBuildingStep,
    meta: {
      browserTitle: "Add a mentor to your team"
    },
  },
]