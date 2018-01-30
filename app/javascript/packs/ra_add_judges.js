import TurbolinksAdapter from 'vue-turbolinks';
import _ from 'lodash';

import Vue from 'vue/dist/vue.esm';
import App from '../app.vue';
import Result from '../result';

Vue.use(TurbolinksAdapter)

document.addEventListener('turbolinks:load', () => {
  const app = new Vue({
    el: '#add-judges',

    data: {
      query: "",
      results: [],
      resultsIdx: 0,
      highlightedResult: null,
      loading: false,
      error: false,
    },

    methods: {
      reset () {
        this.loading = false;
        this.error = false;
        this.query = "";
        this.results = [];
        this.resultsIdx = 0;
        this.highlightedResult = null;
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
          this.setNewResults(this.filterExistingResults());
        } else if (this.query.length >= 3) {
          this.loading = true;
          _.debounce(this.performRemoteSearch, 300)();
        }
      },

      filterExistingResults () {
        return this.results.filter((r) => {
          return r.match(this.query);
        });
      },

      performRemoteSearch () {
        var url = this.$refs.judgeSearch.dataset.fetchUrl +
                  "?keyword=" +
                  this.query;

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
        alert(this.highlightedResult.display);
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
    },
  });
});
