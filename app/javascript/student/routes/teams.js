import Vue from 'vue/dist/vue.esm'

const TeamBuildingStep = Vue.component('team-building-step', {
  template: `<div><slot :name="$route.name">slot named {{ $route.name }}</slot></div>`,
})

export default [
  {
    path: '/parental-consent',
    name: 'parental-consent',
    component: TeamBuildingStep,
  },

  {
    path: '/find-team',
    name: 'find-team',
    component: TeamBuildingStep,
  },

  {
    path: '/create-team',
    name: 'create-team',
    component: TeamBuildingStep,
  }
]