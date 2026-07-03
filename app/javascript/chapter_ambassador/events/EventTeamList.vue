<template>
  <div class="grid">
    <div class="grid__col-12 grid__col--bleed-y">
      <h6 class="heading--reset">
        Selected teams
        <span>({{ event.selectedTeams.length }})</span>
      </h6>
    </div>

    <div
      v-if="fetchingList"
      class="grid__col-12 grid--justify-center grid__col--bleed-y"
    >
      <app-icon name="spinner" class-name="spin" />
      Initating team management...
    </div>

    <template v-else>
      <team-search
        :event-bus-id="`event-${event.id}`"
        :event="event"
      ></team-search>

      <div class="grid__col-12">
        <p>
          <button
            class="button button--small button--remove-bg"
            @click="exportList"
          >
            <app-icon name="download" size="16" />
            Export to CSV
          </button>
        </p>
      </div>
    </template>

    <div
      v-if="!fetchingList && event.selectedTeams.length"
      class="grid__col-12 grid__col--bleed-y"
    >
      <table class="attendee-list">
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
            v-for="team in event.selectedTeams"
            :key="team.id"
            :class="team.recentlyAdded ? 'table-row--new' : ''"
            @mouseover="hoverTeam(team)"
          >
            <td>
              <div v-if="team.hovering" class="attendee-list__actions">
                <app-icon
                  name="remove"
                  size="16"
                  color="ff0000"
                  :handle-click="removeTeam.bind(this, team)"
                />

                <app-icon
                  v-if="event.teamListIsTooLong()"
                  name="gavel"
                  size="16"
                  :handle-click="addJudges.bind(this, team)"
                />
              </div>

              <div class="cutoff-with-ellipsis">
                <a data-turbo="false" target="_blank" :href="team.links.self">
                  {{ team.name }}
                </a>

                <ul class="list--reset list--indented font-small">
                  <li v-for="judge in team.assignedJudges" :key="judge.id">
                    {{ judge.name }}
                  </li>
                </ul>
              </div>
            </td>

            <td>
              {{ team.division }}
            </td>

            <td>
              <div class="cutoff-with-ellipsis">
                <a
                  data-turbo="false"
                  target="_blank"
                  :href="team.links.submission"
                >
                  {{ team.submission.name }}
                </a>
              </div>
            </td>

            <td>
              <label v-if="team.recentlyAdded" class="label--reset">
                <input v-model="team.sendInvitation" type="checkbox" />
                Send invite
              </label>

              <div v-else>
                <span
                  v-tooltip.top-center="team.statusExplained"
                  :class="[
                    'attendee-status',
                    `attendee-status--${team.statusColor}`,
                  ]"
                >
                  {{ team.humanStatus }}
                </span>
              </div>
            </td>

            <attendee-filter
              v-if="team.addingJudges"
              :parent-item="team"
              :child-items="filteredJudges"
              :handle-selection="toggleSelection.bind(this, team)"
              :handle-close="handleClose.bind(this, team)"
              :is-assigned="team.isAssignedToJudge"
              col2-header="Email"
              placeholder="Filter by name or email"
            >
              <template slot="col-2" slot-scope="item">
                <td>{{ item.email }}</td>
              </template>
            </attendee-filter>
          </tr>
        </tbody>
      </table>
    </div>

    <div v-if="newTeamsToSave" class="grid__col-12 align-right">
      <p>
        <button class="button button--small" @click.prevent="saveAssignments">
          Save selected teams
        </button>
      </p>
    </div>
  </div>
</template>

<script>
import AppIcon from "../../components/AppIcon";
import EventBus from "../../components/EventBus";

import TeamSearch from "./TeamSearch";
import AttendeeFilter from "./AttendeeFilter";

export default {
  components: {
    AppIcon,
    TeamSearch,
    AttendeeFilter,
  },

  props: {
    fetchUrl: {
      type: String,
      required: true,
    },

    saveAssignmentsUrl: {
      type: String,
      required: true,
    },

    event: {
      type: Object,
      required: true,
    },
  },
  data() {
    return {
      fetchingList: true,
      judgeFilter: "",
    };
  },

  computed: {
    filteredJudges() {
      return Array.from(this.event.selectedJudges || []).filter((j) =>
        j.matchesQuery(this.judgeFilter)
      );
    },

    newTeamsToSave() {
      return Array.from(this.event.selectedTeams || []).some(
        (t) => t.recentlyAdded
      );
    },
  },

  mounted() {
    EventBus.$on(
      "TeamSearch.selected-event-" + this.event.id,
      (selectedTeam) => {
        this.event.addTeam(selectedTeam);
      }
    );

    EventBus.$on(
      "TeamSearch.deselected-event-" + this.event.id,
      (deselectedTeam) => {
        this.event.removeTeam(deselectedTeam);
        this.$store.commit("removeTeam", deselectedTeam);
      }
    );

    this.event.fetchTeams().then(() => {
      if (!this.event.selectedJudges.length) {
        this.event.fetchJudges().then(() => {
          this.fetchingList = false;
        });
      } else {
        this.fetchingList = false;
      }
    });
  },

  methods: {
    exportList() {
      $.ajax({
        url: `/chapter_ambassador/event_team_list_exports?id=${this.event.id}`,
        method: "POST",
      });
    },

    handleClose(team) {
      team.addingJudges = false;
    },

    toggleSelection(team, judge) {
      if (judge.isAssignedToTeam(team)) {
        judge.unassignTeam(team);
      } else {
        judge.assignTeam(team);
      }
    },

    hoverTeam(team) {
      Array.from(this.event.selectedTeams || []).forEach(
        (t) => (t.hovering = false)
      );
      team.hovering = true;
    },

    addJudges(team) {
      Array.from(this.event.selectedTeams || []).forEach(
        (t) => (t.addJudges = false)
      );
      team.addingJudges = true;
    },

    removeTeam(team) {
      var vm = this,
        modalHtml = team.name;

      modalHtml += !team.recentlyAdded
        ? "<p><small>an email will be sent</small></p>"
        : "<p><small>NO email will be sent</small></p>";

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
              vm.$store.commit("removeTeam", team);
              EventBus.$emit("EventTeamList.removeTeam");
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

    saveAssignments() {
      var form = new FormData();

      Array.from(this.event.selectedTeams || []).forEach((team, idx) => {
        form.append(`event_assignment[invites][${idx}][]id`, team.id);

        form.append(`event_assignment[invites][${idx}][]scope`, team.scope);

        form.append(`event_assignment[invites][${idx}][]name`, team.name);

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

        success: (_resp) => {
          this.event.teamAssignmentsSaved();
          EventBus.$emit("EventTeamList.saveAssignments");
        },

        error: (err) => {
          console.error(err);
        },
      });
    },
  },
};
</script>
