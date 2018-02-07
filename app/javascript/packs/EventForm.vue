<template>
  <div id="new-event">
    <p class="grid__cell--padding-sm">
      <button
        class="button button--small"
        @click="active = true"
        v-if="!active"
      >+ Add an event</button>
    </p>

    <form
      ref="newEvent"
      v-if="active"
      @submit.prevent="handleSubmit"
    >
      <label>
        Event name
        <input type="text" v-model="event.name" />
      </label>

      <errors :errors="eventErrors.name"></errors>

      <label>
        <input
          type="checkbox"
          v-model="event.division_ids"
          :value="seniorDivisionId"
        />
        Senior division
      </label>

      <label>
        <input
          type="checkbox"
          v-model="event.division_ids"
          :value="juniorDivisionId"
        />
        Junior division
      </label>

      <errors :errors="eventErrors.division_ids"></errors>

      <label>
        City
        <input type="text" v-model="event.city" />
      </label>

      <errors :errors="eventErrors.city"></errors>

      <label>
        Venue address
        <input type="text" v-model="event.venue_address" />
      </label>

      <errors :errors="eventErrors.venue_address"></errors>

      <label>
        Date
        <input
          class="flatpickr__date"
          type="text"
          v-model="eventDate"
        />
      </label>

      <div class="grid grid--bleed">
        <div class="grid__col-6">
          <label>
            From
            <input
              class="flatpickr__time"
              type="text"
              v-model="eventStartTime"
            />
          </label>
        </div>

        <div class="grid__col-6">
          <label>
            To
            <input
              class="flatpickr__time"
              type="text"
              v-model="eventEndTime"
            />
          </label>
        </div>
      </div>

      <errors :errors="eventErrors.starts_at"></errors>

      <label>
        Eventbrite URL
        <input type="text" v-model="event.eventbrite_link" />
      </label>

      <input
        type="submit"
        class="button"
        :value="saveBtnTxt"
      />

      or <a @click="reset" href="#">cancel</a>
    </form>
  </div>
</template>

<script>
  import flatpickr from "flatpickr";
  import _ from "lodash";

  import Errors from '../errors';
  import Event from '../event';
  import EventBus from '../event_bus';

  import "flatpickr/dist/themes/material_green.css";

  export default {
    name: "event-form",

    props: [
      "postUrl",
      "seniorDivisionId",
      "juniorDivisionId",
      "juniorDivisionName",
      "seniorDivisionName",
    ],

    data () {
      return {
        httpMethod: "POST",
        saveBtnTxt: "Create this event",
        active: false,
        event: new Event({
          url: this.postUrl,
        }),
        eventErrors: {},
        eventDate: "",
        eventStartTime: "",
        eventEndTime: "",
      };
    },

    computed: {
      url () {
        return this.event.url;
      },

      division_ids () {
        return this.event.division_ids;
      },

      date_time () {
        return this.event.date_time;
      },
    },

    watch: {
      active (val) {
        if (!!val) {
          flatpickr('.flatpickr__date', {
            enableTime: false,
            altInput: true,
            altFormat: "l, F J",
            dateFormat: "Y-m-d",
            minDate: "2018-05-01",
            maxDate: "2018-05-15",
          });

          flatpickr('.flatpickr__time', {
            enableTime: true,
            noCalendar: true,
            minuteIncrement: 15,
            mode: "range",
            minTime: "07:00",
            maxTime: "22:00",
          });
        }
      },

      division_ids (ids) {
        if (!ids || !ids.length) {
          this.event.division_names = "";
          return;
        }

        ids = _.map(ids, i => { return parseInt(i) });
        this.event.division_names = []

        if (ids.includes(parseInt(this.seniorDivisionId)))
          this.event.division_names.push(this.seniorDivisionName);

        if (ids.includes(parseInt(this.juniorDivisionId)))
          this.event.division_names.push(this.juniorDivisionName);

        this.event.division_names = this.event.division_names.join(", ")
      },

      date_time (val) {
        if (!val || !val.length)
          return;

        var startDateTime = this.event.starts_at.split("T"),
            endDateTime = this.event.ends_at.split("T");

        this.eventDate = startDateTime[0];
        this.eventStartTime = startDateTime[1].replace(/:00\.000.+/, "");
        this.eventEndTime = endDateTime[1].replace(/:00\.000.+/, "");
      },

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
      bindError (k, v) {
        this.eventErrors[k] = v;
      },

      reset () {
        this.httpMethod = "POST";
        this.saveBtnTxt = "Create this event";
        this.event = new Event({
          url: this.postUrl,
        });
        this.active = false;
        this.eventDate = "";
        this.eventStartTime = "";
        this.eventEndTime = "";
        this.eventErrors = {};
      },

      updateEventDates () {
        this.event.starts_at = this.eventDate + "T" + this.eventStartTime;
        this.event.ends_at = this.eventDate + "T" + this.eventEndTime;
      },

      handleSubmit () {
        var vm = this,
            form = new FormData();

        form.append("regional_pitch_event[name]", this.event.name);
        form.append("regional_pitch_event[city]", this.event.city);
        form.append("regional_pitch_event[ends_at]", this.event.ends_at);

        _.each(this.event.division_ids, (id) => {
          form.append("regional_pitch_event[division_ids][]", id);
        });

        form.append("regional_pitch_event[venue_address]",
          this.event.venue_address);

        form.append("regional_pitch_event[starts_at]",
          this.event.starts_at);

        form.append("regional_pitch_event[eventbrite_link]",
          this.event.eventbrite_link);

        $.ajax({
          method: this.httpMethod,
          url: vm.url,
          contentType: false,
          processData: false,
          data: form,

          success: (resp) => {
            vm.event.id = resp.id;
            vm.event.url = resp.url;
            vm.event.date_time = resp.date_time;

            EventBus.$emit("eventUpdated", vm.event);

            this.reset();
          },

          error: (resp) => {
            var errors = resp.responseJSON.errors;

            vm.eventErrors = {};

            _.each(Object.keys(errors), (k) => {
              vm.bindError(k, errors[k]);
            });
          },
        });
      },
    },

    components: {
      App,
      Errors,
    },

    mounted () {
      EventBus.$on("editEvent", (event) => {
        this.httpMethod = "PATCH";
        this.active = true;
        this.saveBtnTxt = "Save changes";
        this.event = new Event(event);
        this.event.url = event.url;
      });
    },
  };
</script>

<style scoped>
</style>
