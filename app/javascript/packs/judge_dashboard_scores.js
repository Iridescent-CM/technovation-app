import TurbolinksAdapter from 'vue-turbolinks';

import Vue from 'vue/dist/vue.esm';
import VTooltip from 'v-tooltip';
import Vue2Filters from 'vue2-filters'
import { mapState } from 'vuex'

import store from '../dashboards/judge/scores/store'

import "../components/tooltip.scss";

Vue.use(TurbolinksAdapter)
Vue.use(VTooltip)
Vue.use(Vue2Filters)

$(document).on('ready turbolinks:load', () => {
  new Vue({
    el: '#app',

    store,

    computed: mapState(['hello']),
  })
})
