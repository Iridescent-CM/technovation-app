<template>
  <div id="new-event">
    <p class="grid__cell--padding-sm">
      <button
        class="button button--small"
        @click.prevent="active = true"
        v-if="!active"
      >+ Add an event</button>
    </p>

    <form
      v-if="active"
      @submit.prevent="handleSubmit"
    >
      <div class="grid">
        <div class="grid__col-sm-6">
          <label>
            Event name
            <input type="text" v-model="event.name" />
          </label>

          <errors :errors="eventErrors.name"></errors>
        </div>

        <div class="grid__col-sm-6">
          <h6>Hosting divisions:</h6>

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
        </div>

        <div class="grid__col-sm-6">
          <label>
            City
            <input type="text" v-model="event.city" />
          </label>

          <errors :errors="eventErrors.city"></errors>
        </div>

        <div class="grid__col-sm-6">
          <label>
            Venue address
            <input type="text" v-model="event.venue_address" />
          </label>

          <errors :errors="eventErrors.venue_address"></errors>
        </div>

        <div class="grid__col-sm-6">
          <label>
            Date
            <datetime-input
              v-model="eventDate"
              :options="dateOpts" />
          </label>

          <errors :errors="eventErrors.eventDate"></errors>
        </div>

        <div class="grid__col-6">
          <label>
            From
            <input
              v-model="eventStartTime"
              :picker-options="{
                start: '07:00',
                step: '00:15',
                end: '23:30',
                format: 'HH:mm A',
              }"
              placeholder="Select start time"
            />
          </label>

          <errors :errors="eventErrors.starts_at"></errors>

          <label>
            To
            <input
              v-model="eventEndTime"
              :picker-options="{
                start: '07:00',
                step: '00:15',
                end: '23:30',
                format: 'HH:mm A',
                minTime: eventStartTime,
              }"
              placeholder="Select start time"
            />
          </label>

          <errors :errors="eventErrors.ends_at"></errors>
        </div>

        <div class="grid__col-auto">
          <label>
            Eventbrite URL
            <input type="text" v-model="event.eventbrite_link" />
          </label>

          <p>
            <input
              type="submit"
              class="button"
              :value="saveBtnTxt"
              :disabled="saving"
            />
            or <a @click.prevent="reset" href="#">cancel</a>
          </p>
        </div>
      </div>
    </form>
  </div>
</template>

<script>
  import DatetimeInput from "../../components/DatetimeInput";
  import Errors from '../../components/Errors';
  import EventBus from '../../components/EventBus';

  import Event from './Event';

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
        saving: false,

        dateOpts: {
          enableTime: false,
          altInput: true,
          altFormat: "l, F J",
          dateFormat: "Y-m-d",
          minDate: "2018-05-01",
          maxDate: "2018-05-20",
        },

        timeOpts: {
          enableTime: true,
          noCalendar: true,
          dateFormat: "H:i",
          minuteIncrement: 15,
          minTime: "07:00",
          maxTime: "22:00",
        },

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

      date () {
        return this.event.date;
      },

      time () {
        return this.event.time;
      },
    },

    watch: {
      active (current) {
        if (current)
          EventBus.$emit("EventForm.active");
      },

      division_ids (ids) {
        if (!ids || !ids.length) {
          this.event.division_names = "";
          return;
        }

        ids = Array.from(ids).map((ids, i) => parseInt(i))
        this.event.division_names = []

        if (ids.includes(parseInt(this.seniorDivisionId)))
          this.event.division_names.push(this.seniorDivisionName);

        if (ids.includes(parseInt(this.juniorDivisionId)))
          this.event.division_names.push(this.juniorDivisionName);

        this.event.division_names = this.event.division_names.join(", ")
      },

      date (val) {
        if (!val || !val.length)
          return;

        var startDateTime = this.event.starts_at.split("T"),
            endDateTime = this.event.ends_at.split("T");

        this.eventDate = startDateTime[0];
        this.eventStartTime = startDateTime[1].replace(/:00\.000.+/, "");
        this.eventEndTime = endDateTime[1].replace(/:00\.000.+/, "");
      },

      eventDate () {
        if (this.eventDate.length) {
          this.event.starts_at = this.eventDate + "T" + this.eventStartTime;
          this.event.ends_at = this.eventDate + "T" + this.eventEndTime;
          this.eventErrors.eventDate = [];
        } else {
          this.eventErrors.eventDate = ["can't be blank"];
        }
      },

      eventStartTime () {
        this.event.starts_at = this.eventDate + "T" + this.eventStartTime;
      },

      eventEndTime () {
        this.event.ends_at = this.eventDate + "T" + this.eventEndTime;
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
        this.saving = false;
        EventBus.$emit("EventForm.reset");
      },

      handleSubmit () {
        var vm = this,
            form = new FormData();

        vm.saving = true;

        form.append("regional_pitch_event[name]", vm.event.name);
        form.append("regional_pitch_event[city]", vm.event.city);
        form.append("regional_pitch_event[ends_at]", vm.event.ends_at);

        Array.from(vm.event.division_ids).forEach(id => {
          form.append("regional_pitch_event[division_ids][]", id)
        })

        form.append("regional_pitch_event[venue_address]",
          vm.event.venue_address);

        form.append("regional_pitch_event[starts_at]",
          vm.event.starts_at);

        form.append("regional_pitch_event[eventbrite_link]",
          vm.event.eventbrite_link);

        $.ajax({
          method: vm.httpMethod,
          url: vm.url,
          contentType: false,
          processData: false,
          data: form,

          success: (resp) => {
            vm.event = new Event(resp)
            EventBus.$emit("EventForm.handleSubmit", vm.event);
            vm.reset();
          },

          error: (resp) => {
            var errors = resp.responseJSON.errors;

            vm.eventErrors = {};

            Object.keys(errors).forEach(k => {
              vm.bindError(k, errors[k])
            })
          },

          complete: () => {
            vm.saving = false;
          },
        });
      },
    },

    components: {
      App,
      Errors,
      DatetimeInput,
    },

    mounted () {
      EventBus.$on("EventsTable.editEvent", (event) => {
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
