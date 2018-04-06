import Vue from 'vue/dist/vue.esm';
import VueRouter from 'vue-router'

import LocationForm from '../LocationForm'

export const routes = [
  {
    path: '/',
    name: 'Root',
    component: LocationForm,
  },
]

export const router = new VueRouter({
  routes,
})
