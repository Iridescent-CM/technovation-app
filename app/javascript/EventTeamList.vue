<template>
  <div class="grid">
    <div class="grid__col-12 grid__col--bleed-y">
      <h6 class="heading--reset">
        Selected teams
        <span>({{ this.event.selectedTeams.length }})</span>
      </h6>
    </div>

    <team-search
       v-if="!fetchingList"
       :event-bus-id="`event-${event.id}`"
       :event-id="event.id"
    ></team-search>

    <div class="grid__col-12 grid__col--bleed-y">
      <table class="team-list">
        <thead>
          <tr>
            <th>Name</th>
            <th>Division</th>
            <th>Submission</th>
            <th>Status</th>
          </tr>
        </thead>

        <tbody>
          <tr
            :class="team.recentlyAdded ? 'table-row--new' : ''"
            :key="team.id"
            @mouseover="hoverTeam(team)"
            v-for="team in event.selectedTeams"
          >
            <td>
              <div v-if="team.hovering" class="team-list__actions">
                <icon
                   name="remove"
                   size="16"
                   color="ff0000"
                   :handleClick="removeTeam.bind(this, team)"
                />

                <icon
                   v-if="event.teamListIsTooLong()"
                   name="gavel"
                   size="16"
                   :handleClick="addJudges.bind(this, team)"
                />
              </div>

              <div class="cutoff-with-ellipsis">
                <a
                  data-turbolinks="false"
                  target="_blank"
                  :href="team.links.self"
                >
                  {{ team.name }}
                </a>
              </div>
            </td>

            <td>
              {{ team.division }}
            </td>

            <td>
              <div class="cutoff-with-ellipsis">
                <a
                  data-turbolinks="false"
                  target="_blank"
                  :href="team.links.submission"
                >
                  {{ team.submission.name }}
                </a>
              </div>
            </td>

            <td>
              <label
                class="label--reset"
                v-if="team.recentlyAdded"
              >
                <input type="checkbox" v-model="team.sendInvitation" />
                Send invite
              </label>

              <div v-else>
                <span
                  v-tooltip.top-center="team.statusExplained"
                  :class="[
                    'team-status',
                    `team-status--${team.statusColor}`
                  ]"
                >
                  {{ team.humanStatus }}
                </span>
              </div>
            </td>

            <div
              class="modal-container"
              v-show="team.addingJudges"
            >
              <div class="modal">
                <input
                  type="search"
                  placeholder="Filter by name or email"
                  v-model="judgeFilter"
                />

                <div
                  v-show="filteredJudges(team).length"
                  class="overflow-scroll"
                >
                  <table class="width-full-container headers--left-align">
                    <thead>
                      <tr>
                        <th>Name</th>
                        <th colspan="2">Email</th>
                      </tr>
                    </thead>

                    <tbody>
                      <tr
                        class="cursor-pointer"
                        v-for="judge in filteredJudges(team)"
                        :key="judge.id"
                        @click="toggleSelection(team, judge)"
                      >
                        <td>{{ judge.name }}</td>
                        <td>{{ judge.email }}</td>

                        <td
                          class="light-opacity"
                          v-show="!judge.isSelectedForTeam(team)"
                        >
                          <icon name="check-circle-o" />
                        </td>

                        <td v-show="judge.isSelectedForTeam(team)">
                          <icon name="check-circle" color="228b22" />
                        </td>
                      </tr>
                    </tbody>
                  </table>
                </div>

                <div class="modal-footer">
                  <button
                    class="button--unmask"
                    @click="team.addingJudges = false"
                  >
                    Done
                  </button>
                </div>
              </div>
            </div>
          </tr>
        </tbody>
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

  import Icon from "./Icon";
  import TeamSearch from './TeamSearch';
  import EventBus from './EventBus';

  export default {
    data () {
      return {
        fetchingList: true,
        judgeFilter: "",
      };
    },

    props: [
      'fetchUrl',
      'saveAssignmentsUrl',
      'event',
    ],

    methods: {
      toggleSelection(team, judge) {
        judge.selectedForTeam = team
        console.log('add judge', judge.name, 'to team', team.name)
      },

      hoverTeam (team) {
        _.each(this.event.selectedTeams, t => { t.hovering = false })
        team.hovering = true
      },

      addJudges (team) {
        _.each(this.event.selectedTeams, t => { t.addJudges = false })
        team.addingJudges = true
      },

      removeTeam (team) {
        var vm = this,
            modalHtml = team.name;

        modalHtml += !team.recentlyAdded ?
          "<p><small>an email will be sent</small></p>" :
          "<p><small>NO email will be sent</small></p>";

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

              success: () => {
                vm.event.removeTeam(team);
                vm.$store.commit('removeTeam', team)
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
            this.event.teamAssignmentsSaved();
          },

          error: (err) => {
            console.log(err);
          },
        });
      },

      filteredJudges (team) {
        return _.filter(this.event.selectedJudges, j => {
          return !j.selectedForTeam ||
                   j.isSelectedForTeam(team) &&
                     j.matchesQuery(this.judgeFilter)

        })
      },
    },

    computed: {
      newTeamsToSave () {
        return _.some(this.event.selectedTeams, 'recentlyAdded');
      },
    },

    components: {
      App,
      Icon,
      TeamSearch,
    },

    mounted () {
      EventBus.$on(
        "TeamSearch.selected-event-" + this.event.id,
        (selectedTeam) => { this.event.addTeam(selectedTeam); }
      );

      EventBus.$on(
        "TeamSearch.deselected-event-" + this.event.id,
        (deselectedTeam) => {
          this.event.removeTeam(deselectedTeam);
          this.$store.commit('removeTeam', deselectedTeam)
        }
      );

      this.event.fetchTeams({
        onComplete: () => {
          if (!this.event.selectedJudges.length) {
            this.event.fetchJudges({
              onComplete: () => {
                this.fetchingList = false
              },
            })
          } else {
            this.fetchingList = false;
          }
        },
      });

    },
  };
</script>

<style lang="scss" scoped>
  .team-list {
    width: 100%;

    .team-list__actions {
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

  .team-status {
    display: inline-block;
    padding: 0.25rem 0.5rem;
    color: white;
    font-size: 0.8rem;
  }

  .team-status--green {
    background-color: green;
  }

  .team-status--orange {
    background-color: orange;
  }

  .team-status--red {
    background-color: red;
  }
</style>
