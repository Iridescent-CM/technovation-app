import Vue from 'vue'

const ScoreStep = Vue.component('score-step', {
  template: `<div><slot :name="$route.name">slot named {{ $route.name }}</slot></div>`,
})

export default [
]