<template>
  <div id="add-judges">
    <div class="grid">
      <div class="grid__col-4">
        <input
          ref="judgeSearch"
          class="autocomplete-input"
          type="text"
          placeholder="Search for judges"
          @input="generateResults"
          @keyup.up.prevent="traverseResultsUp"
          @keyup.down.prevent="traverseResultsDown"
          @keyup.enter.prevent="selectHighlighted"
          @keyup.esc="reset"
          v-model="query"
        />
      </div>

      <div
        class="grid__col-auto"
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

    <div class="grid__cell--padding-sm" v-if="loading">
      <i class="icon-spinner2 icon--spin"></i>
    </div>

    <div class="notice notice--error" v-else-if="error">
      Sorry, there was an error on the server

      <button
        class="button button--small button--error"
        @click="reset"
      >
        Reset search and try again
      </button>
    </div>

    <div
      class="notice notice--info"
      v-else-if="searched && !results.length"
    >
      No results found...

      <button
        class="button button--small"
        @click="reset"
      >
        Reset search and try again
      </button>
    </div>

    <table
      class="autocomplete-list"
      v-else
    >
      <tr
        :class="[
          'autocomplete-list__result',
          result.highlightedClass(),
        ]"
        @mouseover="resultsIdx = idx"
        @click="selectHighlighted"
        v-for="(result, idx) in results"
      >
        <td
          v-html="result.highlightMatch('name', query)"
        ></td>

        <td
          v-html="result.highlightMatch('email', query)"
        ></td>

        <td>{{ result.location }}</td>
      </tr>
    </table>

    <div
      class="grid"
      v-if="event.selectedJudges.length"
    >
      <div class="grid__col-12">
        <h6 class="heading--reset">Selected judges</h6>
      </div>

      <div class="grid__col-12 grid__col--bleed-y">
        <table class="judge-list">
          <tr :key="judge.email" v-for="judge in event.selectedJudges">
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
    </div>
  </div>
</template>

<script>
  import _ from 'lodash';

  import Judge from './Judge';

  export default {
    data () {
      return {
        query: "",
        results: [],
        resultsIdx: 0,
        highlightedResult: null,
        loading: false,
        error: false,
        searched: false,
      };
    },

    props: [
      'fetchUrl',
      'fetchListUrl',
      'event',
      'saveHandler',
      'removeJudgeHandler',
    ],

    methods: {
      reset () {
        this.loading = false;
        this.error = false;
        this.searched = false;
        this.query = "";
        this.results = [];
        this.resultsIdx = 0;
        this.highlightedResult = null;
      },

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

      traverseResultsUp () {
        if (this.resultsIdx == 0) {
          this.resultsIdx = this.results.length - 1;
        } else {
          this.resultsIdx--;
        }
      },

      traverseResultsDown () {
        if (this.resultsIdx == this.results.length - 1) {
          this.resultsIdx = 0;
        } else {
          this.resultsIdx++;
        }
      },

      generateResults () {
        if (!this.query.length) {
          this.reset();
        } else if (this.filterExistingResults().length) {
          this.searched = true;
          this.setNewResults(this.filterExistingResults());
        } else if (this.query.length >= 3) {
          this.loading = true;
          this.searched = true;
          _.debounce(this.performRemoteSearch, 300)();
        }
      },

      filterExistingResults () {
        return this.results.filter((r) => {
          return r.match(this.query);
        });
      },

      performRemoteSearch () {
        var url = this.fetchUrl + "?keyword=" + this.query;

        $.ajax({
          method: "GET",
          url: url,
          success: this.setNewResults,
          error: this.indicateError,
        });
      },

      setNewResults (resp) {
        this.results = [];

        [].forEach.call(resp, (result) => {
          this.results.push(new Judge(result));
        });

        this.loading = false;
        this.highlightedResult = this.results[this.resultsIdx];
      },

      indicateError (resp) {
        this.resultsIdx = 0;
        this.loading = false;
        this.error = true;
      },

      selectHighlighted () {
        this.event.addJudge(this.highlightedResult);
        this.reset();
      },

      unhighlightAll () {
        this.results.forEach((r) => { r.unhighlight(); });
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
    },

    mounted () {
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
  .autocomplete-input {
    margin-bottom: 0;
    margin-right: 1rem;
  }

  .autocomplete-list {
    margin: -1.25rem 0 0 1.2rem;
    padding: 0;
    border-collapse: collapse;
    border: 1px solid rgba(0, 0, 0, 0.2);
    box-shadow: 0.2rem 0.2rem 0.2rem rgba(0, 0, 0, 0.2);

    .autocomplete-list__result {
      cursor: pointer;

      td {
        padding: 0.5rem;
        border-bottom: 1px solid rgba(0, 0, 0, 0.2);
        transition: background-color 0.1s;

        &:first-child,
        &:nth-child(2) {
          max-width: 300px;
          overflow: hidden;
          text-overflow: ellipsis;
        }
      }

      &.autocomplete-list__result--highlighted {
        td {
          background: #93bcff;
        }
      }
    }
  }

  input[type=text] {
    max-width: 300px;
  }

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
</style>
