<template>
  <div class="grid__col-12 grid__col--bleed">
    <div class="grid">
      <div class="grid__col-4 grid__col--bleed-y">
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
        class="
          grid__col-8
          notice
          notice--error
          notice--thin
        "
        v-if="error"
      >
        <p>
          Sorry, there was an error on the server

          <button
            class="button button--small button--error"
            @click="reset"
          >
            Reset search and try again
          </button>
        </p>
      </div>

      <div
        class="
          grid__col-8
          notice
          notice--info
          notice--thin
        "
        v-else-if="searched && !results.length"
      >
        <p>
          No results found...

          <button
            class="button button--small"
            @click="reset"
          >
            Reset search and try again
          </button>
        </p>
      </div>

      <div class="grid__col-12" v-if="loading">
        <p>
          <i class="icon-spinner2 icon--spin"></i>
        </p>
      </div>


      <div
        class="grid__col-12 grid__col--bleed-y"
        v-else-if="!!results.length"
      >
        <table class="autocomplete-list">
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
      </div>
    </div>
  </div>
</template>

<script>
  import Judge from './Judge';
  import EventBus from './EventBus';

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
      }
    },

    props: [
      'fetchUrl',
      'excludeIds',
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

      filterExistingResults () {
        return this.results.filter((r) => {
          return r.match(this.query);
        });
      },

      performRemoteSearch () {
        var url = this.fetchUrl + "?keyword=" + this.query;

        _.each(this.excludeIds, (id) => {
          url += "&exclude_ids[]=" + id;
        });

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
        EventBus.$emit("selected", this.highlightedResult);
        this.reset();
      },

      unhighlightAll () {
        this.results.forEach((r) => { r.unhighlight(); });
      },
    },
  };
</script>

<style lang="scss" scoped>
  .autocomplete-input {
    margin-bottom: 0;
    margin-right: 1rem;
  }

  .autocomplete-list {
    margin: 0 0 1rem;
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
</style>
