import "core-js/stable";
import "regenerator-runtime/runtime";

import Vue from 'vue'

import VueRouter from 'vue-router'
import TurbolinksAdapter from 'vue-turbolinks'
import VTooltip from 'v-tooltip'
import Vue2Filters from 'vue2-filters'

import "../components/tooltip.scss"

Vue.use(VueRouter)
Vue.use(TurbolinksAdapter);
Vue.use(VTooltip)
Vue.use(Vue2Filters)

import '../judge/dashboards'
import '../judge/scores'

import "../stylesheets/tailwind.css"
import "../stylesheets/base_forms.css"
import "../stylesheets/layout.css"
import "../stylesheets/judge.css"
