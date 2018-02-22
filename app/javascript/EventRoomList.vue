<template>
  <div class="grid">
    <div class="grid__col-12 grid__col--bleed-y">
      <h6 class="heading--reset">
        Rooms
        <span>({{ this.event.rooms.length }})</span>
      </h6>
    </div>

    <div class="grid__col-12 grid__col--bleed-y">
      <div class="grid">
        <div
          class="grid__col-sm-4"
          v-for="room in event.rooms"
          :key="`room-${room.num}`"
        >
          Room {{ room.num }}

          <div class="grid grid--bleed">
            <div class="grid__col-auto">
              <strong>Teams</strong>

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
              <strong>Judges</strong>

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
  img {
    cursor: pointer;
    opacity: 0;
    transition: opacity 0.2s;
  }

  li:hover img {
    opacity: 1;
  }
</style>
