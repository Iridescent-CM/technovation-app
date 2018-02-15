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
      <h6 class="heading--reset">Selected judges</h6>
    </div>

    <div class="grid__col-12 grid__col--bleed-y">
      <table class="judge-list">
        <tr
          :class="judge.recentlyAdded ? 'table-row--new' : ''"
          :key="judge.email"
          v-for="judge in event.selectedJudges"
        >
          <td>
            <div class="judge-list__actions">
              <img
                alt="remove"
                src="https://icongr.am/fontawesome/remove.svg?size=16&color=ff0000"
                @click.prevent="removeJudge(judge)"
              />
            </div>

            {{ judge.name }}
          </td>

          <td>
            <a :href="`mailto:${judge.email}`">{{ judge.email }}</a>
          </td>

          <td>{{ judge.location }}</td>

          <td v-if="judge.recentlyAdded">
            <label class="label--reset">
              <input type="checkbox" v-model="judge.sendInvitation" />
              Send invite
            </label>
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
          @click.prevent="saveHandler(event)"
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
      'event',
      'saveHandler',
      'removeJudgeHandler',
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
            vm.removeJudgeHandler(vm.event, judge, () => {
              var idx = vm.event.selectedJudges.findIndex(
                j => { return j.id === judge.id }
              );

              if (idx !== -1)
                vm.event.selectedJudges.splice(idx, 1);
            });
          } else {
            return;
          }
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

    watch: {
      highlightedResult (current) {
        this.unhighlightAll();

        if (!!current) {
          this.highlightedResult.highlight();
        } else {
          this.highlightedResult = this.results[0];
        }
      },

      resultsIdx () {
        this.highlightedResult = this.results[this.resultsIdx];
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

    td {
      position: relative;
    }

    .judge-list__actions {
      position: absolute;
      top: 0.25rem;
      left: -1rem;

      img {
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

        &:nth-child(2),
        &:nth-child(3) {
          max-width: 300px;
          overflow: hidden;
          text-overflow: ellipsis;
        }
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
</style>
