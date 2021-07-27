<template>
  <div class="grid">
    <div class="grid__col-12 grid__col--bleed-y">
      <h6 class="heading--reset">
        Selected judges
        <span>({{ this.event.selectedJudges.length }})</span>
      </h6>
    </div>

    <div
      v-if="fetchingList"
      class="grid__col-12 grid--justify-center grid__col--bleed-y"
    >
      <icon name="spinner" className="spin" />
      Initating judge management...
    </div>

    <template v-else>
      <judge-search
        :event-bus-id="`event-${event.id}`"
        :event="event"
      ></judge-search>

      <div class="grid__col-12">
        <p>
          <button
            class="button button--small button--remove-bg"
            @click="exportList"
          >
            <icon name="download" size="16" />
            Export to CSV
          </button>
        </p>
      </div>
    </template>

    <div
      v-if="!fetchingList && event.selectedJudges.length"
      class="grid__col-12 grid__col--bleed-y"
    >
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

              <div class="cutoff-with-ellipsis">
                <template v-if="judge.links.self">
                  <a
                    target="_blank"
                    :href="judge.links.self"
                  >
                    {{ judge.name }}
                  </a>
                </template>

                <template v-else>
                  {{ judge.name }}
                </template>

                <ul class="list--reset list--indented font-small">
                  <li v-for="team in judge.assignedTeams" :key="team.id">
                    {{ team.name }}
                  </li>
                </ul>
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

            <attendee-filter
              v-if="judge.addingTeams"
              :parentItem="judge"
              :childItems="filteredTeams"
              :handleSelection="toggleSelection.bind(this, judge)"
              :handleClose="handleClose.bind(this, judge)"
              :isAssigned="judge.isAssignedToTeam"
              col2Header="Submission"
              placeholder="Filter by team or submission name"
            >
              <template slot="col-2" slot-scope="item">
                <td>{{ item.submission.name }}</td>
              </template>
            </attendee-filter>
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
  import Icon from "../../components/Icon";
  import EventBus from '../../components/EventBus';

  import JudgeSearch from './JudgeSearch';
  import AttendeeFilter from './AttendeeFilter'

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
        return Array.from(this.event.selectedTeams || [])
                    .filter(t => t.matchesQuery(this.teamFilter))
      },
    },

    methods: {
      exportList () {
        $.ajax({
          url: `/chapter_ambassador/event_judge_list_exports?id=${this.event.id}`,
          method: "POST",
        })
      },

      handleClose (judge) {
        judge.addingTeams = false
      },

      toggleSelection(judge, team) {
        if (judge.isAssignedToTeam(team)) {
          judge.unassignTeam(team)
        } else {
          judge.assignTeam(team)
        }
      },

      hoverJudge (judge) {
        Array.from(this.event.selectedJudges || []).forEach(j => j.hovering = false)
        judge.hovering = true
      },

      addTeams (judge) {
        Array.from(this.event.selectedJudges || []).forEach(j => j.addingTeams = false)
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
                if (!judge.recentlyAdded) {
                  EventBus.$emit("EventJudgeList.removeJudge");
                }
                vm.event.removeJudge(judge);
              },

              error: (err) => {
                console.error(err);
              },
            });
          } else {
            return;
          }
        });
      },

      saveAssignments () {
        var form = new FormData();

        Array.from(this.event.selectedJudges || []).forEach((judge, idx) => {
          if (judge.persisted) {
            form.append(
              `event_assignment[invites][${idx}][]id`,
              judge.id
            )
          }

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
            EventBus.$emit("EventJudgeList.saveAssignments");
            this.changesToSave = false;
          },

          error: (err) => {
            console.error(err);
          },
        });
      },
    },

    components: {
      App,
      JudgeSearch,
      Icon,
      AttendeeFilter,
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

      this.event.fetchJudges().then(() => {
        if (!this.event.selectedTeams.length) {
          this.event.fetchTeams().then(() => this.fetchingList = false)
        } else {
          this.fetchingList = false
        }
      })
    },
  };
</script>
