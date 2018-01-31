import TurbolinksAdapter from 'vue-turbolinks';

import Vue from 'vue/dist/vue.esm';
import App from '../app.vue';

import EventBus from '../event_bus';

Vue.use(TurbolinksAdapter)

document.addEventListener('turbolinks:load', () => {
  const app = new Vue({
    el: '#events-list',

    data: {
      events: [],
    },

    methods: {
      editEvent (event) {
        EventBus.$emit("editEvent", event);
        console.log("emitted to EventBus");
      },
    },

    mounted () {
      var url = this.$refs.eventsList.dataset.fetchUrl;

      $.ajax({
        method: "GET",
        url: url,
        success: (resp) => {
          this.events = resp;
        },
      });
    },
  });
});
