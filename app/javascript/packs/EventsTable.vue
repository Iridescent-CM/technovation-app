<template>
  <table class="datagrid">
    <thead>
      <tr>
        <th>Name</th>
        <th>Divisions</th>
        <th>Date &amp; time</th>
        <th>Actions</th>
      </tr>
    </thead>

    <tbody>
      <tr :key="event.id" v-for="event in events">
        <td>{{ event.name }}</td>
        <td>{{ event.division_names }}</td>
        <td>{{ event.date_time }}</td>
        <td>
          <img
            alt="edit"
            class="events-list__action-item"
            src="https://icongr.am/fontawesome/edit.svg?size=16"
            @click="editEvent(event)"
          />

          <img
            alt="remove"
            class="events-list__action-item"
            src="https://icongr.am/fontawesome/remove.svg?size=16&color=ff0000"
            @click="removeEvent(event)"
          />
        </td>
      </tr>
    </tbody>
  </table>
</template>

<script>
  import _ from "lodash";

  import EventBus from '../event_bus';
  import Event from '../event';

  export default {
    name: "events-table",

    props: ["fetchUrl"],

    data () {
      return {
        events: [],
      };
    },

    methods: {
      editEvent (event) {
        EventBus.$emit("editEvent", event);
      },
    },

    mounted () {
      EventBus.$on("eventUpdated", (event) => {
        var idx = this.events.findIndex(e => { return e.id === event.id });

        if (idx !== -1) {
          this.events.splice(idx, 1, event);
        } else {
          this.events.push(event);
        }
      });

      $.ajax({
        method: "GET",
        url: this.fetchUrl,
        success: (resp) => {
          _.each(resp, (event) => {
            this.events.push(new Event(event));
          });
        },
      });
    },
  };
</script>

<style scoped>
</style>
