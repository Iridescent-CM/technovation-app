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
          v-if="editingThisEventOrNone(event)"
          :class="['event-preview', event.managing ? 'open' : '']"
          :key="event.id"
        >
          <td>
            {{ event.name }}
          </td>

          <td>
            {{ event.division_names }}
          </td>

          <td>
            {{ event.day }} <small>{{ event.date }}</small>
          </td>

          <td>
            {{ event.time }} <small>Timezone: {{ event.tz }}</small>
          </td>

          <td>
            <template v-if="managingAttendanceEnabled">
              <img
                alt="edit rooms"
                title="Manage rooms"
                class="events-list__action-item"
                src="https://icongr.am/fontawesome/group.svg?size=16"
                v-tooltip.top-center="editEventRoomsMsg"
                @click.prevent="manageEvent(event, 'managingRooms')"
              />

              <img
                alt="edit teams"
                title="Manage teams"
                class="events-list__action-item"
                src="https://icongr.am/fontawesome/flag.svg?size=16"
                v-tooltip.top-center="editEventTeamsMsg"
                @click.prevent="manageEvent(event, 'managingTeams')"
              />

              <img
                alt="edit judges"
                title="Manage judges"
                class="events-list__action-item"
                src="https://icongr.am/fontawesome/gavel.svg?size=16"
                v-tooltip.top-center="editEventJudgesMsg"
                @click.prevent="manageEvent(event, 'managingJudges')"
              />
            </template>

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
          v-if="!editingOne && event.managing"
        >
          <td colspan="5">
            <event-room-list
              v-if="event.managingRooms"
              :event="event"
              :fetchListUrl="roomsListUrl"
              :saveAssignmentsUrl="saveAssignmentsUrl"
            ></event-room-list>

            <event-judge-list
              v-if="event.managingJudges"
              :event="event"
              :fetchListUrl="judgesListUrl"
              :fetchUrl="searchJudgesUrl"
              :saveAssignmentsUrl="saveAssignmentsUrl"
            ></event-judge-list>

            <event-team-list
              v-if="event.managingTeams"
              :event="event"
              :fetchListUrl="teamsListUrl"
              :fetchUrl="searchTeamsUrl"
              :saveAssignmentsUrl="saveAssignmentsUrl"
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

  import EventRoomList from '../EventRoomList';
  import EventJudgeList from '../EventJudgeList';
  import EventTeamList from '../EventTeamList';

  export default {
    name: "events-table",

    props: [
      "fetchUrl",
      "manageAttendees",
      "saveAssignmentsUrl",
      "roomsListUrl",
      "judgesListUrl",
      "searchJudgesUrl",
      "teamsListUrl",
      "searchTeamsUrl",
    ],

    data () {
      return {
        events: [],
        formActive: false,
        editEventTeamsMsg: "Manage teams",
        editEventJudgesMsg: "Manage judges",
        editEventRoomsMsg: "Manage rooms",
      };
    },

    computed: {
      managingAttendanceEnabled () {
        return this.manageAttendees != "false";
      },

      editingOne () {
        return this.formActive || _.some(this.events, "editing");
      },
    },

    components: {
      EventRoomList,
      EventJudgeList,
      EventTeamList,
    },

    methods: {
      editingThisEventOrNone (event) {
        return event.editing || !this.editingOne;
      },

      manageEvent (event, prop) {
        event.resetManaging();
        event.editing = false;
        event.managing = true;
        event[prop] = !event[prop]
      },

      editEvent (event) {
        event.editing = true;
        _.each(this.events, (e) => { e.managing = false });
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
        this.formActive = false;
        _.each(this.events, (e) => { e.editing = false; });
      });

      EventBus.$on("EventForm.active", () => {
        this.formActive = true;
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
    .open td {
      border: 0;
    }

    .event-manage {
      cursor: auto;

      &:hover td {
        background: none;
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
