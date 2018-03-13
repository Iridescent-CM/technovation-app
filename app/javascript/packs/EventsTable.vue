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
                alt="edit teams"
                title="Manage teams"
                class="events-list__action-item"
                src="https://icongr.am/fontawesome/flag.svg?size=16"
                v-tooltip.top-center="editEventTeamsMsg"
                @click.prevent="event.toggleManaging('managingTeams')"
              />

              <img
                alt="edit judges"
                title="Manage judges"
                class="events-list__action-item"
                src="https://icongr.am/fontawesome/gavel.svg?size=16"
                v-tooltip.top-center="editEventJudgesMsg"
                @click.prevent="event.toggleManaging('managingJudges')"
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
            <event-judge-list
              v-if="event.managingJudges"
              :event="event"
              :fetchUrl="searchJudgesUrl"
              :saveAssignmentsUrl="saveAssignmentsUrl"
            ></event-judge-list>

            <event-team-list
              v-if="event.managingTeams"
              :event="event"
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

  import EventJudgeList from '../EventJudgeList';
  import EventTeamList from '../EventTeamList';

  export default {
    name: "events-table",

    props: [
      "fetchUrl",
      "manageAttendees",
      "saveAssignmentsUrl",
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
      EventJudgeList,
      EventTeamList,
    },

    methods: {
      editingThisEventOrNone (event) {
        return event.editing || !this.editingOne;
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
                  (e) => { return e.id === event.id }
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
        var idx = this.events.findIndex((e) => {
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

            event.fetchTeamsUrlRoot = this.teamsListUrl;
            event.fetchJudgesUrlRoot = this.judgesListUrl;

            this.events.push(new Event(event));
          });
        },
      });
    },
  };
</script>

<style lang="scss">
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

  [type=search] {
    font-size: 0.95rem;
    padding: 0.25rem 1rem;
    border-radius: 50vh;
    background: url("https://icongr.am/fontawesome/search.svg?size=12")
                no-repeat
                right 0.5rem center;
  }

  .position-fixed {
    position: fixed;
    top: 0;
    left: 0;
  }

  .headers--left-align {
    th {
      text-align: left;
    }
  }

  .width-medium {
    width: 60vw;
  }

  .width-full-screen {
    width: 100vw;
  }

  .width-full-container {
    width: 100%;
  }

  .height-full-screen {
    height: 100vh;
  }

  .background-white {
    background: white;
  }

  .background-semi-transparent-dark {
    background: rgba(0, 0, 0, 0.7);
  }

  .display-flex {
    display: flex;
  }

  .display-flex-center {
    @extend .display-flex;
    align-items: center;
    justify-content: center;
  }

  .padding-small {
    padding: 0.5rem;
  }

  .align-center {
    text-align: center;
  }

  .shadow-subtle-white {
    box-shadow: 0 0 2rem rgba(255, 255, 255, 0.5);
  }

  .z-index-penultimate {
    z-index: 999998;
  }

  .z-index-max {
    z-index: 999999;
  }

  .border-radius-small {
    border-radius: 0.2rem;
  }

  .overflow-scroll {
    max-height: 50vh;
    overflow-y: scroll;
  }

  .cursor-pointer {
    cursor: pointer;
    transition: background 0.2s, color 0.2s;
  }

  tr.cursor-pointer {
    &:hover,
    &:hover td {
      background: LavenderBlush;
    }
  }

  button.cursor-pointer {
    &:hover,
    &:hover td {
      color: black;
    }
  }

  .light-opacity {
    opacity: 0.2;
  }

  .background-none {
    background: none;
  }

  .border-none {
    border: none;
  }

  .color-shamrock {
    color: #5ABF94;
  }

  .text-uppercase {
    text-transform: uppercase;
  }

  .font-bold {
    font-weight: bold;
  }

  ul, ol {
    &.list--indented {
      padding-left: 0.5rem;
    }
  }

  .font-small {
    font-size: 0.9rem;
  }

  .button--unmask {
    @extend .background-none;
    @extend .border-none;
    @extend .color-shamrock;
    @extend .text-uppercase;
    @extend .font-bold;
    @extend .cursor-pointer;
  }

  .modal-container {
    @extend .display-flex-center;
    @extend .position-fixed;
    @extend .z-index-penultimate;
    @extend .width-full-screen;
    @extend .height-full-screen;
    @extend .background-semi-transparent-dark;
  }

  .modal {
    @extend .width-medium;
    @extend .padding-small;
    @extend .background-white;
    @extend .shadow-subtle-white;
    @extend .border-radius-small;
    @extend .z-index-max;
    display: block;
  }

  .modal-footer {
    margin: 0 -0.5rem -0.5rem;
    box-shadow: -0.1rem 0 1rem rgba(0, 0, 0, 0.2);
    padding: 0.25rem 0.5rem;
    text-align: right;
  }

  .attendee-list {
    word-break: break-all;
    width: 100%;

    .attendee-list__actions {
      position: relative;

      img {
        position: absolute;
        top: 0.25rem;
        cursor: pointer;

        &:first-child {
          left: -2.5rem;
        }

        &:last-child {
          left: -1.25rem;
        }
      }
    }

    th {
      word-break: keep-all;
      text-align: left;
    }

    > tbody > tr {
      &.table-row--new {
        background: rgba(255, 255, 0, 0.2);

        &:hover,
        &:hover td {
          background: rgba(255, 255, 0, 0.2);
        }
      }

      td {
        padding: 0.25rem;
        width: 0.1%;
        white-space: nowrap;
        vertical-align: top;
      }

      &:hover,
      &:hover > td {
        background: none;
      }
    }
  }

  .align-right {
    text-align: right;
  }

  .cutoff-with-ellipsis {
    overflow: hidden;
    text-overflow: ellipsis;
  }

  h6 span {
    font-weight: normal;
  }

  p {
    margin: 0;
  }

  .attendee-status {
    display: inline-block;
    padding: 0.25rem 0.5rem;
    color: white;
    font-size: 0.8rem;
  }

  .attendee-status--green {
    background-color: green;
  }

  .attendee-status--orange {
    background-color: orange;
  }

  .attendee-status--red {
    background-color: red;
  }

  .swal2-container {
    z-index: 9999999;
  }
</style>
