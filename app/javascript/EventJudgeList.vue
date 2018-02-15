<template>
  <div class="grid">
    <judge-search
       :exclude-ids="event.selectedJudgeIds()"
       :fetch-url="fetchUrl"
    ></judge-search>

    <div
      class="grid__col-12 grid__col-bleed-y"
      v-if="event.selectedJudges.length"
    >
      <h6 class="heading--reset">
        Selected judges <span>({{ this.event.selectedJudges.length }})</span>
      </h6>
    </div>

    <div class="grid__col-12 grid__col--bleed-y">
      <table class="judge-list">
        <tr
          :class="judge.recentlyAdded ? 'table-row--new' : ''"
          :key="judge.email"
          v-for="judge in event.selectedJudges"
        >
          <td class="medium-width">
            <div class="judge-list__actions">
              <img
                alt="remove"
                src="https://icongr.am/fontawesome/remove.svg?size=16&color=ff0000"
                @click.prevent="removeJudge(judge)"
              />
            </div>

            <div class="cutoff-with-ellipsis">
              {{ judge.name }}
            </div>
          </td>

          <td class="medium-width">
            <div class="cutoff-with-ellipsis">
              <a :href="`mailto:${judge.email}`">{{ judge.email }}</a>
            </div>
          </td>

          <td>{{ judge.location }}</td>

          <td v-if="judge.recentlyAdded || judge.recentlyInvited">
            <label
              class="label--reset"
              v-if="judge.recentlyAdded"
            >
              <input type="checkbox" v-model="judge.sendInvitation" />
              Send invite
            </label>

            <div v-else>
              Invite sent!
            </div>
          </td>
        </tr>
      </table>
    </div>

    <div
      class="grid__col-12 align-right"
      v-if="newJudgesToSave"
    >
      <p>
        <button
          class="button button--small"
          @click.prevent="saveJudgeAssignments"
        >
          Save selected judges
        </button>
      </p>
    </div>
  </div>
</template>

<script>
  import _ from 'lodash';

  import Judge from './Judge';
  import JudgeSearch from './JudgeSearch';
  import EventBus from './EventBus';

  export default {
    props: [
      'fetchUrl',
      'fetchListUrl',
      'saveJudgesUrl',
      'event',
    ],

    methods: {
      removeJudge (judge) {
        var vm = this;

        confirmNegativeSwal({
          title: "Remove this judge from " + vm.event.name + "? ",
          text: judge.name + " - " + judge.email,
          confirmButtonText: "Yes, remove this judge",
        }).then((result) => {
          if (result.value) {
            var form = new FormData();

            form.append("judge_assignment[judge_id]", judge.id);
            form.append("judge_assignment[event_id]", vm.event.id);

            $.ajax({
              method: "DELETE",
              url: this.saveJudgesUrl,
              data: form,
              contentType: false,
              processData: false,

              success: (resp) => {
                var idx = vm.event.selectedJudges.findIndex(
                  j => { return j.id === judge.id }
                );

                if (idx !== -1)
                  vm.event.selectedJudges.splice(idx, 1);
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

      saveJudgeAssignments () {
        var form = new FormData();

        _.each(this.event.selectedJudges, (judge) => {
          form.append("judge_assignment[judge_ids][]", judge.id);
        });

        form.append("judge_assignment[event_id]", this.event.id);

        $.ajax({
          method: "POST",
          url: this.saveJudgesUrl,
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
      newJudgesToSave () {
        return _.some(this.event.selectedJudges, (judge) => {
          return judge.recentlyAdded;
        });
      },
    },

    components: {
      App,
      JudgeSearch,
    },

    mounted () {
      EventBus.$on("selected", (selectedJudge) => {
        this.event.addJudge(selectedJudge);
      });

      if (this.event.selectedJudges.length)
        return;

      var vm = this;

      $.ajax({
        method: "GET",
        url: this.fetchListUrl + "?event_id=" + vm.event.id,

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
    },
  };
</script>

<style lang="scss" scoped>
  .judge-list {
    width: 100%;
    table-layout: fixed;

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
</style>
