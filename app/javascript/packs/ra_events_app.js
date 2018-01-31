import TurbolinksAdapter from 'vue-turbolinks';
import Vue from 'vue/dist/vue.esm';

import EventsTable from './EventsTable';
import EventForm from './EventForm';

Vue.use(TurbolinksAdapter)

document.addEventListener('turbolinks:load', () => {
  new Vue({
    el: "#app",

    components: {
      EventsTable,
      EventForm,
    },
  });
});
