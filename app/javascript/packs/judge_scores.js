import TurbolinksAdapter from 'vue-turbolinks';

import Vue from 'vue/dist/vue.esm';
import VTooltip from 'v-tooltip';
import Vue2Filters from 'vue2-filters'

import ScoreStepper from "../judge/scores/ScoreStepper"
import { router } from '../judge/scores/routes'
import store from '../judge/scores/store'

import "../components/tooltip.scss";
import '../judge/scores/main.scss'

import _ from 'lodash'

Vue.use(TurbolinksAdapter);
Vue.use(VTooltip);
Vue.use(Vue2Filters);

$(document).on('ready turbolinks:load', () => {
  new Vue({
    el: "#app",

    router,

    store,

    props: ['scoreId'],

    computed: {
    },

    components: {
      ScoreStepper,
    },

    watch: {
      $route (to, from) {
        this.$store.commit('saveComment', from.name)
      },
    },

    mounted () {
      const score_id = new URLSearchParams(window.location.search)
        .get('score_id')

      $.ajax({
        method: "GET",
        url: `/judge/scores/new.json?score_id=${score_id}`,
        success: json => {
          this.$store.commit('setStateFromJSON', json)
        },
      })
    },
  });
});
