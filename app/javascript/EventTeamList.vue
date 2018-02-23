<template>
  <div class="grid">
    <div class="grid__col-12 grid__col--bleed-y">
      <h6 class="heading--reset">
        Selected teams <span>({{ this.event.selectedTeams.length }})</span>
      </h6>
    </div>

    <team-search
       v-if="!fetchingList"
       :exclude-ids="event.selectedTeamIds()"
       :fetch-url="fetchUrl"
       :event-bus-id="`event-${event.id}`"
    ></team-search>

    <div class="grid__col-12 grid__col--bleed-y">
      <table class="team-list">
        <tr
          :class="team.recentlyAdded ? 'table-row--new' : ''"
          :key="team.id"
          v-for="team in event.selectedTeams"
        >
          <td class="medium-width">
            <div class="team-list__actions">
              <img
                alt="remove"
                src="https://icongr.am/fontawesome/remove.svg?size=16&color=ff0000"
                @click.prevent="removeTeam(team)"
              />
            </div>

            <div class="cutoff-with-ellipsis">
              {{ team.name }}
            </div>
          </td>

          <td>{{ team.location }}</td>

          <td>
            <label
              class="label--reset"
              v-if="team.recentlyAdded"
            >
              <input type="checkbox" v-model="team.sendInvitation" />
              Send invite
            </label>

            <div v-else>
              {{ team.human_status }}
            </div>
          </td>
        </tr>
      </table>
    </div>

    <div
      class="grid__col-12 align-right"
      v-if="newTeamsToSave"
    >
      <p>
        <button
          class="button button--small"
          @click.prevent="saveAssignments"
        >
          Save selected teams
        </button>
      </p>
    </div>
  </div>
</template>

<script>
  import _ from 'lodash';

  import TeamSearch from './TeamSearch';
  import EventBus from './EventBus';

  export default {
    data () {
      return {
        fetchingList: true,
      };
    },

    props: [
      'fetchUrl',
      'saveAssignmentsUrl',
      'event',
    ],

    methods: {
      removeTeam (team) {
        var vm = this,
            modalHtml = team.name;

        modalHtml += !team.recentlyAdded ?
          "<small>an email will be sent</small>" :
          "<small>NO email will be sent</small>";

        confirmNegativeSwal({
          title: "Remove this team from " + vm.event.name + "? ",
          html: modalHtml,
          confirmButtonText: "Yes, remove this team",
        }).then((result) => {
          if (result.value) {
            var form = new FormData();

            form.append("event_assignment[attendee_scope]", team.scope);
            form.append("event_assignment[attendee_id]", team.id);
            form.append("event_assignment[event_id]", vm.event.id);

            $.ajax({
              method: "DELETE",
              url: this.saveAssignmentsUrl,
              data: form,
              contentType: false,
              processData: false,

              success: (resp) => {
                var idx = vm.event.selectedTeams.findIndex(
                  t => { return t.id === team.id }
                );

                if (idx !== -1)
                  vm.event.selectedTeams.splice(idx, 1);
              },

              error: (err) => {
                console.log(err);
              },
            });
          } else {
            return;
          }
        });
      },

      saveAssignments () {
        var form = new FormData();

        _.each(this.event.selectedTeams, (team, idx) => {
          form.append(
            `event_assignment[invites][${idx}][]id`,
            team.id
          )

          form.append(
            `event_assignment[invites][${idx}][]scope`,
            team.scope
          )

          form.append(
            `event_assignment[invites][${idx}][]name`,
            team.name
          )

          form.append(
            `event_assignment[invites][${idx}][]send_email`,
            team.sendInvitation
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
            this.event.afterTeamSave();
          },

          error: (err) => {
            console.log(err);
          },
        });
      },
    },

    computed: {
      newTeamsToSave () {
        return _.some(this.event.selectedTeams, 'recentlyAdded');
      },
    },

    components: {
      App,
      TeamSearch,
    },

    mounted () {
      EventBus.$on(
        "TeamSearch.selected-event-" + this.event.id,
        (selectedTeam) => { this.event.addTeam(selectedTeam); }
      );

      this.event.fetchTeams({
        onComplete: () => {
          this.fetchingList = false;
        },
      });
    },
  };
</script>

<style lang="scss" scoped>
  .team-list {
    width: 100%;
    table-layout: fixed;

    .team-list__actions {
      position: relative;

      img {
        position: absolute;
        top: 0.25rem;
        left: -1rem;
        cursor: pointer;
        pointer-events: none;
        opacity: 0;
        transition: opacity 0.2s;
      }
    }

    tr {
      &.table-row--new {
        background: rgba(255, 255, 0, 0.2);

        &:hover,
        &:hover td {
          background: rgba(255, 255, 0, 0.2);
        }
      }

      td {
        padding: 0.25rem;

      }

      &:hover,
      &:hover td {
        background: none;
      }

      &:hover {
        .team-list__actions {
          img {
            pointer-events: auto;
            opacity: 1;
          }
        }
      }
    }
  }

  .align-right {
    text-align: right;
  }

  .medium-width {
    width: 225px;
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
</style>
