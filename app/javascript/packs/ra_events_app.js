import TurbolinksAdapter from 'vue-turbolinks';
import Vue from 'vue/dist/vue.esm';
import VTooltip from 'v-tooltip';

import EventsTable from './EventsTable';
import EventForm from './EventForm';

import "flatpickr/dist/themes/material_green.css";
import "tooltip.scss";

import ElementUI from 'element-ui'
import locale from 'element-ui/lib/locale/lang/en'
import 'element-ui/lib/theme-chalk/index.css'

Vue.use(TurbolinksAdapter);
Vue.use(VTooltip);
Vue.use(ElementUI, { locale });

document.addEventListener('ready turbolinks:load', () => {
  new Vue({
    el: "#app",

    components: {
      EventsTable,
      EventForm,
    },
  });
});
