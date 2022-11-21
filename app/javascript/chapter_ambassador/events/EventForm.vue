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
              type="radio"
              name="division"
              v-model="eventDivision"
              :value="seniorDivisionId"
            />
            Senior division
          </label>

          <label>
            <input
              type="radio"
              name="division"
              v-model="eventDivision"
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

          <errors :errors="eventErrors.date"></errors>
        </div>

        <div class="grid__col-6">
          <label>
            From
            <datetime-input
              v-model="eventStartTime"
              :options="startDateInputOptions"
            />
          </label>

          <errors :errors="eventErrors.starts_at"></errors>

          <label>
            To
            <datetime-input
              v-model="eventEndTime"
              :options="endDateInputOptions"
            />
          </label>

          <errors :errors="eventErrors.ends_at"></errors>
        </div>

        <div class="grid__col-sm-6">
          <label>
            <input
              type="checkbox"
              v-model="showCapacity"
            />
            Set a cap on the number of teams that can attend
          </label>

          <label class="padding--t-medium" v-if="showCapacity">
            Capacity
            <integer-input input-name="capacity" v-model="event.capacity" />
          </label>

          <errors :errors="eventErrors.capacity"></errors>
        </div>

        <div class="grid__col-12">
          <label>
            Event URL (Optional)
            <input type="text" v-model="event.event_link" />
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
  import IntegerInput from 'components/IntegerInput';

  import Event from './Event';

  import { isEmptyObject } from 'utilities/utilities';

  export default {
    name: "event-form",

    components: {
      App,
      Errors,
      DatetimeInput,
      IntegerInput,
    },

    props: [
      "postUrl",
      "juniorDivisionId",
      "juniorDivisionName",
      "seniorDivisionId",
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
          minDate: this.minDate(),
          maxDate: this.maxDate(),
        },

        timeOpts: {
          enableTime: true,
          noCalendar: true,
          dateFormat: "H:i",
          time_24hr: true,
          minuteIncrement: 15,
          minTime: "07:00",
          maxTime: "23:30",
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
        eventDivision: null,

        showCapacity: false,
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

      startDateInputOptions () {
        return Object.assign({}, this.timeOpts, {
          onClose: (_selectedDates, dateStr, instance) => {
            if (this.eventEndTime !== "") {
              const startTime = this.createTimeFromString(dateStr);
              const endTime = this.createTimeFromString(this.eventEndTime);
              if (startTime > endTime) {
                this.eventEndTime = "";
              }
            }
          }
        });
      },

      endDateInputOptions () {
        return Object.assign({}, this.timeOpts, {
          onOpen: (_selectedDates, _dateStr, instance) => {
            if (this.eventStartTime !== "") {
              const startTime = this.createTimeFromString(this.eventStartTime);

              let endTime = 0;
              if (this.eventEndTime !== "") {
                endTime = this.createTimeFromString(this.eventEndTime);
              }

              if (startTime > endTime) {
                this.eventEndTime = this.eventStartTime;
              }

              instance.set('minTime', startTime);
            }
          },
        });
      }
    },

    watch: {
      active (current) {
        if (current)
          EventBus.$emit("EventForm.active");
      },

      eventDivision (divisionId) {
        if (!!divisionId) {
          this.event.division_ids = [divisionId];
        } else {
          this.event.division_ids = [];
        }
      },

      division_ids (ids) {
        if (!ids || !ids.length) {
          this.event.division_names = "";
          return;
        }

        ids = Array.from(ids || []).map((ids, i) => parseInt(i))
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
        if (this.eventDate.length && this.eventStartTime) {
          this.event.starts_at = this.eventDate + "T" + this.eventStartTime;
        }

        if (this.eventDate.length && this.eventEndTime) {
          this.event.ends_at = this.eventDate + "T" + this.eventEndTime;
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
        this.showCapacity = false;
        this.eventErrors = {};
        this.saving = false;
        EventBus.$emit("EventForm.reset");
      },

      handleSubmit () {
        const vm = this;
        const form = new FormData();

        vm.saving = true;

        const isValid = this.validateInput();
        if (!isValid) {
          vm.saving = false;
          return false;
        }

        form.append("regional_pitch_event[name]", vm.event.name);
        form.append("regional_pitch_event[city]", vm.event.city);
        form.append("regional_pitch_event[starts_at]", vm.event.starts_at);
        form.append("regional_pitch_event[ends_at]", vm.event.ends_at);

        Array.from(vm.event.division_ids || []).forEach(id => {
          form.append("regional_pitch_event[division_ids][]", id)
        })

        form.append("regional_pitch_event[venue_address]",
          vm.event.venue_address);

        form.append("regional_pitch_event[event_link]",
          vm.event.event_link);

        if (this.showCapacity && Boolean(vm.event.capacity)) {
          form.append("regional_pitch_event[capacity]", vm.event.capacity);
        } else {
          form.append("regional_pitch_event[capacity]", null);
        }

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

      /**
       * We have to do front-end validation in addition to back-end validation
       * here due to the fact that "date" doesn't exist on the model in Rails
       */
      validateInput() {
        this.eventErrors = {};

        if (!this.event.name) {
          this.eventErrors.name = ["can't be blank"];
        }

        if (!this.event.city) {
          this.eventErrors.city = ["can't be blank"];
        }

        if (!this.eventDate) {
          this.eventErrors.date = ["can't be blank"];
        }

        if (!this.event.starts_at) {
          this.eventErrors.starts_at = ["can't be blank"];
        }

        if (!this.event.ends_at) {
          this.eventErrors.ends_at = ["can't be blank"];
        }

        if (!Array.from(this.event.division_ids || []).length) {
          this.eventErrors.division_ids = ["can't be blank"];
        }

        if (!this.event.venue_address) {
          this.eventErrors.venue_address = ["can't be blank"];
        }

        if (this.showCapacity && !this.event.capacity) {
          this.eventErrors.capacity = ["can't be blank or zero"];
        }

        if (!isEmptyObject(this.eventErrors)) {
          return false;
        }

        return true;
      },

      createTimeFromString(twentyFourHourTime) {
        const newTime = new Date();
        const timeParts = twentyFourHourTime.split(':');
        newTime.setHours(
          parseInt(timeParts[0], 10),
          parseInt(timeParts[1], 10),
          0
        );
        return newTime;
      },

      minDate() {
        return process.env.DATES_REGIONAL_PITCH_EVENTS_BEGINS_YEAR + '-' +
          process.env.DATES_REGIONAL_PITCH_EVENTS_BEGINS_MONTH + '-' +
          process.env.DATES_REGIONAL_PITCH_EVENTS_BEGINS_DAY
      },

      maxDate() {
        return process.env.DATES_REGIONAL_PITCH_EVENTS_ENDS_YEAR + '-' +
          process.env.DATES_REGIONAL_PITCH_EVENTS_ENDS_MONTH + '-' +
          process.env.DATES_REGIONAL_PITCH_EVENTS_ENDS_DAY
      },
    },

    mounted () {
      EventBus.$on("EventsTable.editEvent", (event) => {
        this.httpMethod = "PATCH";
        this.active = true;
        this.saveBtnTxt = "Save changes";
        this.event = new Event(event);
        this.event.url = event.url;
        this.showCapacity = Boolean(this.event.capacity);

        // TODO - This EventForm functionality only allows for a single division
        // to be selected to satisfy #1950. On the back-end, we allow for more than
        // one division to be selected for an event, so we are only limiting that
        // on the front-end. Between seasons, we should modify the back-end to only
        // allow one division for a given event.
        if (
          this.event.division_ids.length === 1 &&
          parseInt(this.event.division_ids[0], 10) === parseInt(this.seniorDivisionId, 10)
        ) {
          this.eventDivision = parseInt(this.seniorDivisionId, 10);
        } else if (
          this.event.division_ids.length === 1 &&
          parseInt(this.event.division_ids[0], 10) === parseInt(this.juniorDivisionId, 10)
        ) {
          this.eventDivision = parseInt(this.juniorDivisionId, 10);
        } else {
          this.eventDivision = null;
          this.event.division_ids = [];
        }
      });
    },
  };
</script>

<style scoped>
</style>
