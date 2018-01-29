import TurbolinksAdapter from 'vue-turbolinks';
import { Datetime } from 'vue-datetime';

import Vue from 'vue/dist/vue.esm'
import App from '../app.vue'

import 'vue-datetime/dist/vue-datetime.css';

Vue.use(TurbolinksAdapter)

document.addEventListener('turbolinks:load', () => {
  const app = new Vue({
    el: '#events',
    data: {
      event: {
        name: "",
        city: "",
        venue_address: "",
        divisions: [],
        starts_at: "2018-05-05T18:00:00.000",
        ends_at: "2018-05-05T22:00:00.000",
      },

      minDatetime: "2018-05-01T00:00:00.000Z",
      maxDatetime: "2018-05-15T23:59:59.000Z",

    },

    computed: {
    },

    methods: {
    },

    components: {
      App,
      Datetime,
    },

    mounted () {
    },
  });
});
