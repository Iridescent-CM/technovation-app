<template>
  <div class="grid__col-12 grid__col--bleed">
    <div class="search-components grid">
      <div
        class="grid__col-12 grid__col--bleed-y"
        v-show="activelySearching"
      >
        <p>
          <input
            ref="nameSearch"
            class="autocomplete-input"
            type="text"
            placeholder="Name"
            @input="generateResults"
            @keyup.up.prevent="traverseResultsUp"
            @keyup.down.prevent="traverseResultsDown"
            @keyup.enter.prevent="selectHighlighted"
            @keyup.esc="reset"
            v-model="nameQuery"
          />

          <input
            ref="emailSearch"
            class="autocomplete-input"
            type="email"
            placeholder="Email"
            @input="generateResults"
            @keyup.up.prevent="traverseResultsUp"
            @keyup.down.prevent="traverseResultsDown"
            @keyup.enter.prevent="selectHighlighted"
            @keyup.esc="reset"
            v-model="emailQuery"
          />

          <button
            class="
              button
              button--inline
              button--small
              button--remove-bg
              button--black-text
            "
            v-if="searched && !results.length"
            @click="addWithInvite"
          >
            <img
              alt="remove"
              src="https://icongr.am/fontawesome/envelope-o.svg?size=16"
            />
            Add and invite
          </button>
        </p>
      </div>

      <div
        class="
          grid__col-12
          notice
          notice--info
          notice--thin
        "
        v-if="searched && !results.length"
      >
        <p>
          We couldn't find someone. You can invite them by email.
        </p>
      </div>

      <div
        class="
          grid__col-12
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
        class="grid__col-12 grid__col--bleed-y"
        v-show="!activelySearching"
      >
        <p>
          <button
            class="button button--small button--remove-bg"
            @click.prevent="searching = true"
          >+ Add judges</button>
        </p>
      </div>

      <div
        class="grid__col-12"
        v-if="loading || !!results.length"
      >
        <div class="autocomplete-list">
          <div
            class="grid__cell--padding-sm"
            v-if="loading"
          >
            <p>
              <i class="icon-spinner2 icon--spin"></i>
            </p>
          </div>

          <table>
            <tr
             :class="[
               'autocomplete-list__result',
               resultsIdx === idx ?
                'autocomplete-list__result--highlighted' : '',
             ]"
             @mouseover="highlightResult(idx)"
             @click="selectHighlighted(idx)"
             v-for="(result, idx) in results"
             >
             <td
             v-html="result.highlightMatch('name', nameQuery)"
             ></td>

             <td
             v-html="result.highlightMatch('email', emailQuery)"
             ></td>

             <td>{{ result.location }}</td>
            </tr>
          </table>
        </div>
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
        nameQuery: "",
        emailQuery: "",
        results: [],
        invite: { email: "" },
        resultsIdx: null,
        highlightedResult: null,
        loading: false,
        error: false,
        searched: false,
        searching: false,
      }
    },

    props: [
      'fetchUrl',
      'excludeIds',
      'eventBusId',
    ],

    computed: {
      activelySearching () {
        return this.searching || _.isEmpty(this.excludeIds);
      },
    },

    watch: {
      searching () {
        var vm = this;
      },
    },

    methods: {
      addWithInvite () {
        // TODO - it's not always a highlighted result anymore
        // this is a new judge that needs to sign up

        this.highlightedResult = new Judge({
          name: this.nameQuery,
          email: this.emailQuery,
          scope: "UserInvitation",
        });

        this.selectHighlighted();
      },

      highlightResult (idx) {
        this.resultsIdx = idx;
        this.unhighlightAll();

        var result = this.results[idx];

        if (!result)
          result = this.results[0];

        if (!!result) {
          result.highlight();
          this.highlightedResult = result;
        }
      },

      reset () {
        this.loading = false;
        this.error = false;
        this.searched = false;
        this.nameQuery = "";
        this.emailQuery = "";
        this.results = [];
        this.highlightedResult = null;
      },

      generateResults () {
        var queryEmpty = !this.nameQuery.length &&
                           !this.emailQuery.length,
            enoughQueryForRemote = this.nameQuery.length >= 3 ||
                                     this.emailQuery.length >=3;

        this.searching = true;

        if (queryEmpty) {
          this.reset();
        } else if (this.filterExistingResults().length) {
          this.searched = true;
          this.setNewResults(this.filterExistingResults());
        } else if (enoughQueryForRemote) {
          this.loading = true;
          _.debounce(this.performRemoteSearch, 300)();
        }
      },

      traverseResultsUp () {
        if (this.resultsIdx == 0) {
          this.highlightResult(this.results.length - 1);
        } else {
          this.highlightResult(this.resultsIdx - 1);
        }
      },

      traverseResultsDown () {
        if (this.ResultsIdx == this.results.length - 1) {
          this.highlightResult(0);
        } else {
          this.highlightResult(this.resultsIdx + 1);
        }
      },

      filterExistingResults () {
        return this.results.filter((r) => {
          return r.match(this.nameQuery, this.emailQuery);
        });
      },

      performRemoteSearch () {
        var vm = this,
            url = vm.fetchUrl + "?name=" + vm.nameQuery +
                                "&email=" + vm.emailQuery;

        _.each(vm.excludeIds, (id) => {
          url += "&exclude_ids[]=" + id;
        });

        $.ajax({
          method: "GET",
          url: url,
          success: vm.setNewResults,
          error: vm.indicateError,
          complete: () => {
            vm.searched = true;
          },
        });
      },

      setNewResults (resp) {
        this.results = [];

        [].forEach.call(resp, (result) => {
          this.results.push(new Judge(result));
        });

        this.loading = false;
        this.highlightResult(0);
      },

      indicateError (resp) {
        this.highlightResult(0);
        this.loading = false;
        this.error = true;
      },

      selectHighlighted (idx) {
        EventBus.$emit(
          "JudgeSearch.selected-" + this.eventBusId,
          this.highlightedResult
        );

        this.reset();
      },

      unhighlightAll () {
        this.results.forEach((r) => { r.unhighlight(); });
      },
    },

    mounted () {
    },
  };
</script>

<style lang="scss" scoped>
  .autocomplete-input {
    margin-bottom: 0;
    margin-right: 1rem;
    display: inline-block;
    width: 250px;
  }

  .search-components {
    position: relative;
  }

  .autocomplete-list {
    width: 100%;
    width: 100%;
    position: absolute;
    top: -0.6rem;
    left: 1.2rem;
    background: white;
    z-index: 1058; /* $z-under-shade */

    table {
      padding: 0;
      border-collapse: collapse;
      border: 1px solid rgba(0, 0, 0, 0.2);
      box-shadow: 0.2rem 0.2rem 0.2rem rgba(0, 0, 0, 0.2);
    }

    .autocomplete-list__result {
      cursor: pointer;
      background: none;

      &:hover,
      &:hover td {
        background: none;
      }

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
