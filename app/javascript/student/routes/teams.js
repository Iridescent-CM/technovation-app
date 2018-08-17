import Vue from 'vue/dist/vue.esm'

const Test = Vue.component('test', {
  template: `<div>Hi test: {{ content }} :: {{ $route.name }}</div>`,
  data () {
    return {
      content: 'none',
    }
  },

  mounted () {
    this.content = this.$refs.parentalConsent.innerHtml
  }
})

export default [
  {
    path: '/parental-consent',
    name: 'parental-consent',
    component: Test,
  },

  {
    path: '/find-team',
    name: 'find-team',
    component: Test,
  },

  {
    path: '/create-team',
    name: 'create-team',
    component: Test,
  }
]