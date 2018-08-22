import Vue from 'vue/dist/vue.esm'

const ScoreStep = Vue.component('score-step', {
  template: `<div><slot :name="$route.name">slot named {{ $route.name }}</slot></div>`,
})

export default [
]