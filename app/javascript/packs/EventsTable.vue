<template>
  <table class="datagrid">
    <thead>
      <tr>
        <th>Name</th>
        <th>Divisions</th>
        <th>Date</th>
        <th>Time</th>
        <th>Actions</th>
      </tr>
    </thead>

    <tbody>
      <template v-for="event in events">
        <tr
          v-if="managingOrNotEditing(event)"
          :class="['event-preview', event.managing ? 'open' : '']"
          :key="event.id"
        >
          <td @click="event.managing = !event.managing; editingOne = false">
            {{ event.name }}
          </td>

          <td @click="event.managing = !event.managing; editingOne = false">
            {{ event.division_names }}
          </td>

          <td @click="event.managing = !event.managing; editingOne = false">
            {{ event.day }} <small>{{ event.date }}</small>
          </td>

          <td @click="event.managing = !event.managing; editingOne = false">
            {{ event.time }} <small>Timezone: {{ event.tz }}</small>
          </td>

          <td>
            <img
              alt="edit"
              class="events-list__action-item"
              src="https://icongr.am/fontawesome/edit.svg?size=16"
              @click.prevent="editEvent(event)"
            />

            <img
              alt="remove"
              class="events-list__action-item"
              src="https://icongr.am/fontawesome/remove.svg?size=16&color=ff0000"
              @click.prevent="removeEvent(event)"
            />
          </td>
        </tr>

        <tr
          class="event-manage"
          :key="event.id + '-manage'"
          v-if="event.managing && !editingOne"
        >
          <td colspan="5">
            <event-judge-list
              :event="event"
              :fetchListUrl="judgesListUrl"
              :fetchUrl="searchJudgesUrl"
              :saveJudgesUrl="saveJudgesUrl"
            ></event-judge-list>

            <event-team-list
              :event="event"
              :fetchListUrl="teamsListUrl"
              :fetchUrl="searchTeamsUrl"
              :saveTeamsUrl="saveTeamsUrl"
            ></event-team-list>
          </td>
        </tr>
      </template>
    </tbody>
  </table>
</template>

<script>
  import _ from "lodash";

  import EventBus from '../EventBus';
  import Event from '../Event';

  import EventJudgeList from '../EventJudgeList';
  import EventTeamList from '../EventTeamList';

  export default {
    name: "events-table",

    props: [
      "fetchUrl",
      "saveJudgesUrl",
      "judgesListUrl",
      "searchJudgesUrl",
      "saveTeamsUrl",
      "teamsListUrl",
      "searchTeamsUrl",
    ],

    data () {
      return {
        events: [],
        editingOne: false,
      };
    },

    watch: {
      editingOne (current) {
        if (current)
          _.each(this.events, (e) => { e.managing = false; });
      },
    },

    components: {
      EventJudgeList,
      EventTeamList,
    },

    methods: {
      managingOrNotEditing (event) {
        return !this.editingOne || event.managing;
      },

      editEvent (event) {
        this.editingOne = true;
        EventBus.$emit("EventsTable.editEvent", event);
      },

      removeEvent (event) {
        confirmNegativeSwal({
          text: "Delete this event? " + event.name,
          confirmButtonText: "Yes, delete this event",
        }).then((result) => {
          if (result.value) {
            $.ajax({
              method: "DELETE",
              url: event.url,
              success: () => {
                var idx = this.events.findIndex(
                  e => { return e.id === event.id }
                );

                if (idx !== -1)
                  this.events.splice(idx, 1);
              },
            });
          } else {
            return;
          }
        });
      },
    },

    mounted () {
      EventBus.$on("EventForm.handleSubmit", (event) => {
        var idx = this.events.findIndex(e => {
          return e.id === event.id;
        });

        if (idx !== -1) {
          this.events.splice(idx, 1, event);
        } else {
          this.events.push(event);
        }
      });

      EventBus.$on("EventForm.reset", () => {
        this.editingOne = false;
      });

      EventBus.$on("EventForm.active", () => {
        this.editingOne = true;
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

<style lang="scss" scoped>
  small {
    display: block;
    opacity: 0.7;
    font-weight: 600;
  }

  .datagrid {
    .event-preview {
      cursor: pointer;

      &:hover,
      &:hover td {
        background: rgba(220, 220, 220, 0.25);
      }

      &.open td {
        border: 0;
      }
    }

    .event-manage {
      cursor: auto;

      &:hover {
        td {
          background: none;
        }
      }
    }
  }

  .events-list__action-item {
    padding: 0 0.5rem;
    cursor: pointer;
    transition: transform 0.2s;

    &:hover {
      transform: scale(1.15);
    }
  }
</style>
