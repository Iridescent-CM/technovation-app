<template>
  <div class="grid">
    <div class="grid__col-12 grid__col--bleed-y">
      <h6 class="heading--reset">
        Selected judges
        <span>({{ this.event.selectedJudges.length }})</span>
      </h6>
    </div>

    <judge-search
       v-if="!fetchingList"
       :event-bus-id="`event-${event.id}`"
       :event-id="event.id"
    ></judge-search>

    <div class="grid__col-12 grid__col--bleed-y">
      <table class="attendee-list">
        <thead>
          <tr>
            <th>Name</th>
            <th>Email</th>
            <th>Status</th>
          </tr>
        </thead>

        <tbody>
          <tr
            v-for="judge in event.selectedJudges"
            @mouseover="hoverJudge(judge)"
            :class="judge.recentlyAdded ? 'table-row--new' : ''"
            :key="judge.email"
          >
            <td>
              <div v-if="judge.hovering" class="attendee-list__actions">
                <icon
                  name="remove"
                  size="16"
                  color="ff0000"
                  :handleClick="removeJudge.bind(this, judge)"
                />

                <icon
                   v-if="event.teamListIsTooLong()"
                   name="flag"
                   size="16"
                   :handleClick="addTeams.bind(this, judge)"
                />
              </div>

              <div
                v-if="judge.links.self"
                class="cutoff-with-ellipsis"
              >
                <a
                  data-turbolinks="false"
                  target="_blank"
                  :href="judge.links.self"
                >
                  {{ judge.name }}
                </a>

                <ul class="list--reset list--indented font-small">
                  <li v-for="team in judge.assignedTeams">
                    {{ team.name }}
                  </li>
                </ul>
              </div>

              <div
                v-else
                class="cutoff-with-ellipsis"
              >
                {{ judge.name }}
              </div>
            </td>

            <td>
              <div class="cutoff-with-ellipsis">
                <a :href="`mailto:${judge.email}`">{{ judge.email }}</a>
              </div>
            </td>

            <td>
              <label
                class="label--reset"
                v-if="judge.recentlyAdded"
              >
                <input type="checkbox" v-model="judge.sendInvitation" />
                Send invite
              </label>

              <div v-else>
                <span
                  v-tooltip.top-center="judge.statusExplained"
                  :class="[
                    'attendee-status',
                    `attendee-status--${judge.statusColor}`
                  ]"
                >
                  {{ judge.humanStatus }}
                </span>
              </div>
            </td>

            <div
              class="modal-container"
              v-show="judge.addingTeams"
            >
              <div class="modal">
                <input
                  type="search"
                  placeholder="Filter by team or submission name"
                  v-model="teamFilter"
                />

                <div
                  v-show="filteredTeams.length"
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
                        v-for="team in filteredTeams"
                        :key="team.id"
                        @click="toggleSelection(judge, team)"
                      >
                        <td>{{ team.name }}</td>
                        <td>{{ team.submission.name }}</td>

                        <td
                          class="light-opacity"
                          v-show="!team.isAssignedToJudge(judge)"
                        >
                          <icon name="check-circle-o" />
                        </td>

                        <td v-show="team.isAssignedToJudge(judge)">
                          <icon name="check-circle" color="228b22" />
                        </td>
                      </tr>
                    </tbody>
                  </table>
                </div>

                <div class="modal-footer">
                  <button
                    class="button--unmask"
                    @click="judge.addingTeams = false"
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
      v-if="changesToSave"
    >
      <p>
        <button
          class="button button--small"
          @click.prevent="saveAssignments"
        >
          Save changes
        </button>
      </p>
    </div>
  </div>
</template>

<script>
  import _ from 'lodash';

  import Icon from "./Icon";
  import JudgeSearch from './JudgeSearch';
  import EventBus from './EventBus';

  export default {
    data () {
      return {
        fetchingList: true,
        changesToSave: false,
        teamFilter: "",
      };
    },

    props: [
      'fetchUrl',
      'saveAssignmentsUrl',
      'event',
    ],

    computed: {
      filteredTeams ()  {
        return _.filter(this.event.selectedTeams, t => {
          return t.matchesQuery(this.teamFilter)
        })
      },
    },

    methods: {
      toggleSelection(judge, team) {
        if (team.isAssignedToJudge(judge)) {
          team.unassignJudge(judge)
          judge.unassignTeam(team)
        } else {
          team.assignJudge(judge)
          judge.assignTeam(team)
        }
      },

      hoverJudge (judge) {
        _.each(this.event.selectedJudges, j => { j.hovering = false })
        judge.hovering = true
      },

      addTeams (judge) {
        _.each(this.event.selectedJudges, j => { j.addingTeams = false })
        judge.addingTeams = true
      },

      removeJudge (judge) {
        var vm = this,
            modalHtml = judge.name + " - " + judge.email;

        modalHtml += !judge.recentlyAdded ?
          "<p><small>an email will be sent</small></p>" :
          "<p><small>NO email will be sent</small></p>";

        confirmNegativeSwal({
          title: "Remove this judge from " + vm.event.name + "? ",
          html: modalHtml,
          confirmButtonText: "Yes, remove this judge",
        }).then((result) => {
          if (result.value) {
            var form = new FormData();

            form.append("event_assignment[attendee_scope]", judge.scope);
            form.append("event_assignment[attendee_id]", judge.id);
            form.append("event_assignment[event_id]", vm.event.id);

            $.ajax({
              method: "DELETE",
              url: this.saveAssignmentsUrl,
              data: form,
              contentType: false,
              processData: false,

              success: (resp) => {
                vm.event.removeJudge(judge);
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
            this.event.judgeAssignmentsSaved();
            this.changesToSave = false;
          },

          error: (err) => {
            console.log(err);
          },
        });
      },
    },

    components: {
      App,
      JudgeSearch,
      Icon,
    },

    mounted () {
      EventBus.$on(
        "JudgeSearch.selected-event-" + this.event.id, (judge) => {
          this.event.addJudge(judge);
          this.changesToSave = true;
        }
      );

      EventBus.$on(
        "JudgeSearch.deselected-event-" + this.event.id, (judge) => {
          this.removeJudge(judge);
        }
      );

      this.event.fetchJudges({
        onComplete: () => {
          if (!this.event.selectedTeams.length) {
            this.event.fetchTeams({
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
