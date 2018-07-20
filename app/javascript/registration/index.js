import Vue from 'vue/dist/vue.esm'
import router from './routes'

document.addEventListener('turbolinks:load', () => {
  const wizardElem = document.querySelector('#vue-enable-signup-wizard')

  if (wizardElem) {
    new Vue({
      el: wizardElem,
      router,
    })
  }
})