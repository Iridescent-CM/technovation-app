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
      <table class="judge-list">
        <thead>
          <tr>
            <th>Name</th>
            <th>Email</th>
            <th>Status</th>
          </tr>
        </thead>

        <tbody>
          <tr
            :class="judge.recentlyAdded ? 'table-row--new' : ''"
            :key="judge.email"
            v-for="judge in event.selectedJudges"
          >
            <td>
              <div class="judge-list__actions">
                <icon
                  name="remove"
                  size="16"
                  color="ff0000"
                  :handleClick="removeJudge.bind(this, judge)"
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
                    'judge-status',
                    `judge-status--${judge.statusColor}`
                  ]"
                >
                  {{ judge.humanStatus }}
                </span>
              </div>
            </td>
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
      };
    },

    props: [
      'fetchUrl',
      'saveAssignmentsUrl',
      'event',
    ],

    methods: {
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
          this.fetchingList = false;
        },
      });
    },
  };
</script>

<style lang="scss" scoped>
  .judge-list {
    width: 100%;

    .judge-list__actions {
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

    th {
      text-align: left;
    }

    tr {
      margin: 0 0 0.25rem;

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
        .judge-list__actions {
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

  .judge-status {
    display: inline-block;
    padding: 0.25rem 0.5rem;
    color: white;
    font-size: 0.8rem;
  }

  .judge-status--green {
    background-color: green;
  }

  .judge-status--orange {
    background-color: orange;
  }

  .judge-status--red {
    background-color: red;
  }

</style>

<style>
  .swal2-container {
    z-index: 9999999;
  }
</style>
