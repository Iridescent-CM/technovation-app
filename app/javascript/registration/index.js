import Vue from 'vue/dist/vue.esm'
import App from './App'

document.addEventListener('turbolinks:load', () => {
  const wizardElem = document.querySelector('#vue-enable-signup-wizard')

  if (wizardElem) {
    new Vue({
      el: wizardElem,

      components: {
        App
      },
    })
  }
})