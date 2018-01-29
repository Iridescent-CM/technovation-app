import TurbolinksAdapter from 'vue-turbolinks';
import Vue from 'vue/dist/vue.esm'
import App from '../app.vue'

Vue.use(TurbolinksAdapter)

document.addEventListener('turbolinks:load', () => {
  const app = new Vue({
    el: '#events',
    data: {
      message: "Hello, RAs! The Technovation development team is " +
               "hard at work on this section right now. " +
               "Stay tuned for email announcements.",
    },

    computed: {
    },

    methods: {
    },

    components: {
      App,
    },

    mounted () {
    },
  });
});
