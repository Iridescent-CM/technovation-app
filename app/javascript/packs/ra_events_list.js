import TurbolinksAdapter from 'vue-turbolinks';

import Vue from 'vue/dist/vue.esm';
import App from '../app.vue';

Vue.use(TurbolinksAdapter)

document.addEventListener('turbolinks:load', () => {
  const app = new Vue({
    el: '#events-list',

    data: {
      events: [],
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
