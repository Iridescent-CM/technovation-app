import TurbolinksAdapter from 'vue-turbolinks';
import Vue from 'vue/dist/vue.esm';
import VTooltip from 'v-tooltip';

import EventsTable from './EventsTable';
import EventForm from './EventForm';

Vue.use(TurbolinksAdapter);
Vue.use(VTooltip);

import "flatpickr/dist/themes/material_green.css";
import "tooltip.scss";

document.addEventListener('turbolinks:load', () => {
  new Vue({
    el: "#app",

    components: {
      EventsTable,
      EventForm,
    },
  });
});
