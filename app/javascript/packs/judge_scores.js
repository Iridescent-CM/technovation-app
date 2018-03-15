import TurbolinksAdapter from 'vue-turbolinks';
import Vue from 'vue/dist/vue.esm';
import Vuex from 'vuex'

Vue.use(Vuex)

import VTooltip from 'v-tooltip';

import "../components/tooltip.scss";

Vue.use(TurbolinksAdapter);
Vue.use(VTooltip);

const store = new Vuex.Store({
  state: { },
  mutations: { }
})

$(document).on('ready turbolinks:load', () => {
  new Vue({
    el: "#app",

    store,

    components: { },
  });
});
