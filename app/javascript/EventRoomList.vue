<template>
  <div class="grid">
    <div class="grid__col-12 grid__col--bleed-y">
      <p>
        With 15 or more teams attending your event, we recommend
        that you group them, so that the judges can focus on only
        a handful of teams.
      </p>

      <h6 class="heading--reset">
        Rooms
        <span>({{ this.event.rooms.length }})</span>
      </h6>
    </div>

    <div class="grid__col-12 grid__col--bleed-y">
      <p>
        <button
          class="button button--small"
          @click="addRoom"
        >
          + Create a room
        </button>
      </p>

      <div class="grid">
        <div
          class="grid__col-sm-4"
          v-for="(room, idx) in event.rooms"
          :key="`room-${room.num}`"
        >
          <p>
            <img
              alt="remove"
              src="https://icongr.am/fontawesome/remove.svg?size=16&color=ff0000"
              @click.prevent="removeRoom(idx)"
            />
            Room {{ room.num }}
          </p>

          <div class="grid grid--bleed">
            <div class="grid__col-auto">
              <strong>
                Teams (<a @click="addTeam(room)">+</a>)
              </strong>

              <ul class="list--reset">
                <li
                  v-for="(team, i) in room.teams"
                  :key="`room-${room.num}-team-${team.id}`"
                >
                  <img
                    alt="remove"
                    src="https://icongr.am/fontawesome/remove.svg?size=16&color=ff0000"
                    @click.prevent="removeTeam(room, i)"
                  />
                  {{ team.name }}
                </li>
              </ul>
            </div>

            <div class="grid__col-auto">
              <strong>
                Judges (<a @click="addJudge(room)">+</a>)
              </strong>

              <ul class="list--reset">
                <li
                  v-for="(judge, i) in room.judges"
                  :key="`room-${room.num}-judge-${judge.id}`"
                >
                  <img
                    alt="remove"
                    src="https://icongr.am/fontawesome/remove.svg?size=16&color=ff0000"
                    @click.prevent="removeJudge(room, i)"
                  />
                  {{ judge.name }}
                </li>
              </ul>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
  import _ from 'lodash';

  import EventBus from './EventBus';
  import Room from "./Room";

  export default {
    data () {
      return {
        fetchingList: true,
      };
    },

    props: [
      'fetchListUrl',
      'saveAssignmentsUrl',
      'event',
    ],

    methods: {
      addRoom () {
        var num = this.event.rooms.length + 1;
        var room = new Room({ num: num });
        this.event.rooms.push(room);
      },

      addJudge (room) {
        var judge = {
          id: room.judges.length + 1,
          name: "Judgey judge",
        };
        room.judges.push(judge);
      },

      addTeam (room) {
        var team = {
          id: room.teams.length + 1,
          name: "Teamy team cats",
        };
        room.teams.push(team);
      },

      removeRoom (idx) {
        this.event.rooms.splice(idx, 1);
        _.each(this.event.rooms, (r, i) => {
          r.num = i + 1;
        });
      },

      removeTeam (room, idx) {
        room.teams.splice(idx, 1);
      },

      removeJudge (room, idx) {
        room.judges.splice(idx, 1);
      },

      saveAssignments () {
        var form = new FormData();

        _.each(this.event.selectedJudges, (judge, idx) => {
          form.append(
            `event_assignment[invites][${idx}][]id`,
            judge.id
          )

          form.append(
            `event_assignment[invites][${idx}][]scope`,
            judge.scope
          )

          form.append(
            `event_assignment[invites][${idx}][]email`,
            judge.email
          )

          form.append(
            `event_assignment[invites][${idx}][]name`,
            judge.name
          )

          form.append(
            `event_assignment[invites][${idx}][]send_email`,
            judge.sendInvitation
          );
        });

        form.append("event_assignment[event_id]", this.event.id);

        $.ajax({
          method: "POST",
          url: this.saveAssignmentsUrl,
          data: form,
          contentType: false,
          processData: false,

          success: (resp) => {
            this.event.afterSave();
          },

          error: (err) => {
            console.log(err);
          },
        });
      },
    },

    computed: {
    },

    components: {
      App,
    },

    mounted () {
    },
  };
</script>

<style lang="scss" scoped>
  a {
    cursor: pointer;
  }

  img {
    cursor: pointer;
    opacity: 0;
    transition: opacity 0.2s;
  }

  li:hover, p:hover {
    img {
      opacity: 1;
    }
  }
</style>
