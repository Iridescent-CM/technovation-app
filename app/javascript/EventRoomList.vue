<template>
  <div class="grid">
    <div class="grid__col-12 grid__col--bleed-y">
      <p>
        With 15 or more teams attending your event, we recommend
        that you group them, so that the judges can focus on only
        a handful of teams. No emails will be sent while you organize
        this section.
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

  import Room from "./Room";
  import Team from './Team';
  import Judge from './Judge';

  export default {
    data () {
      return {
        fetchingList: true,
      };
    },

    props: [
      'fetchRoomListUrl',
      'fetchJudgeListUrl',
      'fetchTeamListUrl',
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
        var vm = this;

        async function addRoomJudge () {
          const judgeId = await vm.promptSelection({
            collection: vm.event.selectedJudges,
            title: "Add a judge to Room " + room.num,
            sortBy: "name",
            valueProp: "id",
            textProp: "name",
            prompt: "Select a judge",
          });

          if (judgeId)
            room.judges.push(new Judge({ id: judgeId, name: "foo" }));
        }

        addRoomJudge();
      },

      addTeam (room) {
        var vm = this;

        async function addRoomTeam () {
          const teamId = await vm.promptSelection({
            collection: vm.event.selectedTeams,
            title: "Add a team to Room " + room.num,
            sortBy: "name",
            valueProp: "id",
            textProp: "name",
            prompt: "Select a team",
          });

          if (teamId)
            room.teams.push(new Team({ id: teamId, name: "bar" }));
        }

        addRoomTeam();
      },

      promptSelection (opts) {
        var sorted = _.sortBy(opts.collection, opts.sortBy),
            inputOptions = {};

            _.each(sorted, (s) => {
              inputOptions[s[opts.valueProp]] = s[opts.textProp];
            });

        async function promptForSelection () {
          const { value: selection } = await swal({
            title: opts.title,
            input: "select",
            inputPlaceholder: opts.prompt,
            inputOptions: inputOptions,
            showCancelButton: true,
          });

          return selection;
        }

        return promptForSelection();
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
      var vm = this;

      if (!vm.event.selectedTeams.length) {
        $.ajax({
          method: "GET",
          url: this.fetchTeamListUrl + "?event_id=" + vm.event.id,

          success: (resp) => {
            _.each(resp, (result) => {
              var team = new Team(result);
              vm.event.selectedTeams.push(team)
            });
          },

          error: (err) => {
            console.log(err);
          },
        });
      }

      if (!vm.event.selectedJudges.length) {
        $.ajax({
          method: "GET",
          url: this.fetchJudgeListUrl + "?event_id=" + vm.event.id,

          success: (resp) => {
            _.each(resp, (result) => {
              var judge = new Judge(result);
              vm.event.selectedJudges.push(judge)
            });
          },

          error: (err) => {
            console.log(err);
          },
        });
      }
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
