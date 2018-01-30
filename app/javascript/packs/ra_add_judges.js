import TurbolinksAdapter from 'vue-turbolinks';
import _ from 'lodash';

import Vue from 'vue/dist/vue.esm'
import App from '../app.vue'

Vue.use(TurbolinksAdapter)

function Result (res) {
  this.name = res.name;
  this.email = res.email;
  this.highlighted = false;

  this.display = res.name + " - " + res.email;

  this.highlight = () => {
    this.highlighted = true;
  };

  this.unhighlight = () => {
    this.highlighted = false;
  };

  this.highlightedClass = () => {
    if (this.highlighted)
      return "autocomplete-list__result--highlighted"
  };

  this.match = (pattern) => {
    var regexp = new RegExp(pattern, "i");

    return !!this.name.match(regexp) ||
      !!this.email.match(regexp);
  };

  this.highlightMatch = (query) => {
    var regexp = new RegExp("(" + query + ")", "gi");
    return this.display.replace(regexp, "<b>$1</b>");
  };
}

document.addEventListener('turbolinks:load', () => {
  const app = new Vue({
    el: '#add-judges',

    data: {
      judge: {
        name: "",
        email: "",
      },

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

      search () {
        if (!this.query.length)
          this.reset();

        var vm = this,
            url = vm.$refs.judgeSearch.dataset.fetchUrl +
                  "?keyword=" +
                  vm.query;

        var filtered = vm.results.filter((r) => {
          return r.match(vm.query);
        });

        if (filtered.length) {
          vm.results = filtered;
        } else if (vm.query.length >= 3) {
          vm.loading = true;

          _.debounce(() => {
            $.ajax({
              method: "GET",
              url: url,

              success: (resp) => {
                vm.results = [];

                [].forEach.call(resp, (result) => {
                  vm.results.push(new Result(result));
                });

                vm.loading = false;
              },

              error: (resp) => {
                vm.resultsIdx = 0;
                vm.loading = false;
                vm.error = true;
              },
            });
          }, 300)();
        }
      },

      selectHighlighted () {
        alert(this.results[this.resultsIdx].display);
      },

      unhighlightAll () {
        this.results.forEach((r) => { r.unhighlight(); });
      },
    },

    computed: {
    },

    watch: {
      highlightedResult (current) {
        if (!!current) {
          this.unhighlightAll();
          this.highlightedResult.highlight();
        }
      },

      resultsIdx () {
        this.highlightedResult = this.results[this.resultsIdx];
      },

      results (current, old) {
        if (current.length != old.length)
          this.resultsIdx = 0;
      },
    },

    components: {
      App,
    },

    mounted () {
    },
  });
});
