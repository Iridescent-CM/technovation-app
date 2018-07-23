import Vue from 'vue/dist/vue.esm'
import VueRouter from 'vue-router'

import AdminContentSettings from './components/AdminContentSettings'

Vue.use(VueRouter)

import store from './store'
import { router } from './routes'

document.addEventListener('turbolinks:load', () => {
  const adminContentSettingsElement = document.getElementById('admin-content-settings')

  if (adminContentSettingsElement) {
    new Vue({
      router,
      store,
      el: adminContentSettingsElement,
      components: {
        AdminContentSettings,
      },
    })
  }
})
