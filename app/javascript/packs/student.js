import "babel-polyfill"
import Vue from 'vue/dist/vue.esm'

import VueRouter from 'vue-router'
import TurbolinksAdapter from 'vue-turbolinks'
import VTooltip from 'v-tooltip'
import Vue2Filters from 'vue2-filters'

import _ from 'lodash'

import "../components/tooltip.scss"

Vue.use(VueRouter)
Vue.use(TurbolinksAdapter);
Vue.use(VTooltip)
Vue.use(Vue2Filters)

import '../student'