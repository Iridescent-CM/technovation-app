<template>
  <div class="vue-events-table grid">
    <template v-for="event in events">
      <div
        v-if="editingThisEventOrNone(event)"
        :class="['grid__col-12', event.managing ? 'open' : '']"
        :key="event.id"
      >
        <div class="grid grid--bleed">
          <div class="grid__col-12">
            <h5>
              <template v-if="event.event_link">
                <a :href="event.event_link" target="_blank">
                  {{ event.name }}
                </a>
              </template>
              <template v-else>
                {{ event.name }}
              </template>
            </h5>
          </div>

          <div class="grid__col-auto">
            <small>Divisions</small>
            {{ event.division_names }}
          </div>

          <div class="grid__col-auto">
            <small>Date</small>
            {{ `${event.day}, ${event.date}` }}
          </div>

          <div class="grid__col-auto">
            <small>Time</small>
            {{ `${event.time} (${event.tz})` }}
          </div>

          <div class="grid__col-auto">
            <small>Status</small>
            {{ event.officiality }}
          </div>

          <div class="grid__col-auto text-align--right">
            <small>Team Capacity</small>
            {{ teamCapacityText(event) }}
          </div>

          <div class="grid__col-3 text-align--right">
            <div class="grid__cell">
              <template v-if="managingAttendanceEnabled">
                <icon
                  alt="edit teams"
                  title="Manage teams"
                  className="events-list__action-item"
                  name="flag"
                  size="16"
                  v-tooltip.top-center="editEventTeamsMsg"
                  :handleClick="
                    event.toggleManaging.bind(event, 'managingTeams')
                  "
                />

                <icon
                  alt="edit judges"
                  title="Manage judges"
                  className="events-list__action-item"
                  name="gavel"
                  size="16"
                  v-tooltip.top-center="editEventJudgesMsg"
                  :handleClick="
                    event.toggleManaging.bind(event, 'managingJudges')
                  "
                />
              </template>

              <icon
                alt="print"
                className="events-list__action-item"
                name="print"
                size="16"
                v-tooltip.top-center="`Print for live event`"
                :handleClick="goToPrintUrl.bind(this, event)"
              />

              <icon
                alt="edit"
                className="events-list__action-item"
                name="edit"
                size="16"
                :handleClick="editEvent.bind(this, event)"
              />

              <icon
                alt="remove"
                className="events-list__action-item"
                name="remove"
                size="16"
                color="ff0000"
                :handleClick="removeEvent.bind(this, event)"
              />
            </div>
          </div>
        </div>

        <div
          class="event-manage"
          :key="event.id + '-manage'"
          v-if="!editingOne && event.managing"
        >
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
        </div>
      </div>
    </template>
  </div>
</template>

<script>
  import Icon from '../../components/Icon';
  import EventBus from '../../components/EventBus';

  import Event from './Event';
  import EventJudgeList from './EventJudgeList';
  import EventTeamList from './EventTeamList';

  export default {
    name: "events-table",

    props: [
      "fetchUrl",
      "saveAssignmentsUrl",
      "judgesListUrl",
      "searchJudgesUrl",
      "teamsListUrl",
      "searchTeamsUrl",
      "manageAttendees",
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
        const editingEvent = this.events.some((event) => {
          return Boolean(event.editing)
        })
        return this.formActive || editingEvent
      },
    },

    components: {
      EventJudgeList,
      EventTeamList,
      Icon,
    },

    methods: {
      goToPrintUrl (event) {
        window.location.href = `/chapter_ambassador/printable_scores/${event.id}`
      },

      editingThisEventOrNone (event) {
        return event.editing || !this.editingOne;
      },

      editEvent (event) {
        event.editing = true;
        this.events.forEach((e) => { e.managing = false })
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

      teamCapacityText (event) {
        if (!event.capacity) {
          return "Unlimited";
        }

        return event.capacity;
      },
    },

    mounted () {
      EventBus.$on("EventForm.handleSubmit", (event) => {
        var idx = this.events.findIndex((e) => {
          return e.id === event.id;
        });

        event.fetchTeamsUrlRoot = this.teamsListUrl;
        event.fetchJudgesUrlRoot = this.judgesListUrl;

        if (idx !== -1) {
          this.events.splice(idx, 1, event);
        } else {
          this.events.push(event);
        }
      });

      EventBus.$on("EventForm.reset", () => {
        this.formActive = false;
        this.events.forEach((e) => { e.editing = false; })
      });

      EventBus.$on("EventForm.active", () => {
        this.formActive = true;
      });

      $.ajax({
        method: "GET",
        url: this.fetchUrl,
        success: (resp) => {
          Array.from(resp).forEach((event) => {
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
  .vue-events-table {
    small {
      display: block;
      opacity: 0.7;
      font-weight: 600;
    }

    .events-list__action-item {
      display: inline-block;
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
      z-index: 9998;
    }

    .z-index-max {
      z-index: 9999;
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

    button.cursor-pointer {
      &:hover {
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

    .color-secondary {
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
      @extend .color-secondary;
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

      tr {
        &.row--new {
          background: rgba(255, 255, 0, 0.2);

          &:hover {
            background: rgba(255, 255, 0, 0.2);
          }
        }

        td {
          vertical-align: top;

          ul li:last-child {
            margin-bottom: 1rem;
          }
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

    .event-manage {
      padding: 1rem 0;
    }
  }

  .swal2-container, #flash.fixed {
    z-index: 9999999;
  }
</style>
