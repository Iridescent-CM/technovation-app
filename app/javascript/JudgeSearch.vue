<template>
  <div id="add-judges">
    <label>
      Find judges to assign

      <input
        ref="judgeSearch"
        class="autocomplete-input"
        type="text"
        @input="generateResults"
        @keyup.up.prevent="traverseResultsUp"
        @keyup.down.prevent="traverseResultsDown"
        @keyup.enter.prevent="selectHighlighted"
        @keyup.esc="reset"
        v-model="query"
      />
    </label>

    <div class="grid__cell--padding-sm" v-if="loading">
      <i class="icon-spinner2 icon--spin"></i>
    </div>

    <div class="notice notice--error" v-else-if="error">
      Sorry, there was an error on the server

      <button
        class="button button--small button--error"
        @click="reset"
      >
        Reset and try again
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
        Reset and try again
      </button>
    </div>

    <ul
      class="autocomplete-list"
      v-else
    >
      <li
        :class="[
          'autocomplete-list__result',
          result.highlightedClass(),
        ]"
        @mouseover="resultsIdx = idx"
        @click="selectHighlighted"
        v-html="result.highlightMatch(query)"
        v-for="(result, idx) in results"
      ></li>
    </ul>

    <div
      class="grid__cell--padding-sm"
      v-if="event.selectedJudges.length"
    >
      Selected judges:

      <table class="judge-list">
        <tr :key="judge.email" v-for="judge in event.selectedJudges">
          <td>{{ judge.name }}</td>

          <td>{{ judge.email }}</td>

          <td class="judge-list__actions">
            <img
              alt="remove"
              src="https://icongr.am/fontawesome/remove.svg?size=16&color=ff0000"
              @click.prevent="removeJudge(judge)"
            />
          </td>
        </tr>

        <tr v-if="event.dirty">
          <td colspan="3">
            <button
              class="button button--small button--right"
              @click.prevent="saveHandler(event)"
            >
              Save judges list
            </button>
          </td>
        </tr>
      </table>
    </div>
  </div>
</template>

<script>
  import _ from 'lodash';

  import Result from './result';

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

        vm.removeJudgeHandler(vm.event, judge, () => {
          var idx = vm.event.selectedJudges.findIndex(
            j => { return j.id === judge.id }
          );

          if (idx !== -1)
            vm.event.selectedJudges.splice(idx, 1);
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
          this.results.push(new Result(result));
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
        this.event.selectedJudges.push(this.highlightedResult);
        this.event.dirty = true;
        this.reset();
      },

      unhighlightAll () {
        this.results.forEach((r) => { r.unhighlight(); });
      },
    },

    computed: {
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
            var judge = new Result(result);
            vm.event.selectedJudges.push(judge)
          });

          vm.event.dirty = false;
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
  }

  .autocomplete-list {
    list-style: none;
    margin: 0;
    padding: 0;
    border: solid rgba(0, 0, 0, 0.2);
    box-shadow: 0.2rem 0.2rem 0.2rem rgba(0, 0, 0, 0.2);
    border-width: 0 1px;

    .autocomplete-list__result {
      padding: 0.5rem;
      border-bottom: 1px solid rgba(0, 0, 0, 0.2);
      cursor: pointer;
      transition: background-color 0.1s;

      &.autocomplete-list__result--highlighted {
        background: #93bcff;
      }
    }
  }

  .button--right {
    float: right;
  }

  .judge-list {
    width: 100%;

    .judge-list__actions img {
      cursor: pointer;
      pointer-events: none;
      opacity: 0;
      transition: opacity 0.2s;
    }

    tr {
      &:hover,
      &:hover td {
        background: none;
      }

      &:hover {
        .judge-list__actions img {
          pointer-events: auto;
          opacity: 1;
        }
      }
    }
  }
</style>
