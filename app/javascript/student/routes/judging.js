import Vue from 'vue/dist/vue.esm'

const JudgingStep = Vue.component('judging-step', {
  template: `<div><slot :name="$route.name">slot named {{ $route.name }}</slot></div>`,
})

export default [
  {
    path: '/events',
    name: 'events',
    component: JudgingStep,
    meta: {
      browserTitle: "Attend a live regional event"
    },
  },
]