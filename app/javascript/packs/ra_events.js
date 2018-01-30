import TurbolinksAdapter from 'vue-turbolinks';
import flatpickr from "flatpickr";
import _ from "lodash";

import Vue from 'vue/dist/vue.esm';
import App from '../app.vue';
import Errors from '../errors.vue';

import "flatpickr/dist/themes/material_green.css";

Vue.use(TurbolinksAdapter)

document.addEventListener('turbolinks:load', () => {
  const app = new Vue({
    el: '#new-event',
    data: {
      active: false,

      event: {
        name: "",
        city: "",
        venue_address: "",
        divisions: [],
        errors: {},
      },

      eventDate: "",
      eventStartTime: "",
      eventEndTime: "",
    },

    computed: {
    },

    watch: {
      eventDate () {
        this.updateEventDates();
      },

      eventStartTime () {
        this.updateEventDates();
      },

      eventEndTime () {
        this.updateEventDates();
      },
    },

    methods: {
      reset () {
        this.event = {};
        this.active = false;
      },

      updateEventDates () {
        this.event.starts_at = this.eventDate + " " + this.eventStartTime;
        this.event.ends_at = this.eventDate + " " + this.eventEndTime;
      },

      handleSubmit () {
        var url = this.$refs.newEvent.dataset.fetchUrl,
            form = new FormData();

        form.append("regional_pitch_event[name]", this.event.name);
        form.append("regional_pitch_event[city]", this.event.city);
        form.append("regional_pitch_event[ends_at]", this.event.ends_at);

        form.append("regional_pitch_event[division_ids][]",
          this.event.divisions);

        form.append("regional_pitch_event[venue_address]",
          this.event.venue_address);

        form.append("regional_pitch_event[starts_at]",
          this.event.starts_at);

        form.append("regional_pitch_event[eventbrite_link]",
          this.event.eventbrite_link);

        $.ajax({
          method: "POST",
          url: url,
          contentType: false,
          processData: false,
          data: form,

          success: (resp) => {
            this.reset();
          },

          error: (resp) => {
            var errors = resp.responseJSON.errors;

            _.each(Object.keys(errors), (k) => {
              this.event.errors[k] = errors[k];
            });
          },
        });
      },
    },

    components: {
      App,
      Errors,
    },

    updated () {
      if (this.active) {
        flatpickr('.flatpickr--date', {
          altInput: true,
          enableTime: false,
          altFormat: "l, F J",
          minDate: "2018-05-01",
          maxDate: "2018-05-15",
        });

        flatpickr('.flatpickr--time', {
          enableTime: true,
          noCalendar: true,
          minuteIncrement: 15,
          mode: "range",
          minTime: "07:00",
          maxTime: "22:00",
        });
      }
    },
  });
});
