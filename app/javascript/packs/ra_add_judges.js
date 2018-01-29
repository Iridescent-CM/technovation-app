import TurbolinksAdapter from 'vue-turbolinks';
import _ from 'lodash';

import Vue from 'vue/dist/vue.esm'
import App from '../app.vue'

Vue.use(TurbolinksAdapter)

document.addEventListener('turbolinks:load', () => {
  const app = new Vue({
    el: '#add-judges',

    data: {
      judge: {
        name: "",
        email: "",
      },

      judgeQuery: "",

      searchResults: [],
    },

    methods: {
      searchJudges () {
        if (this.judgeQuery.length < 3)
          return;

        var vm = this,
            url = vm.$refs.judgeSearch.dataset.fetchUrl +
                  "?keyword=" +
                  vm.judgeQuery;

        _.debounce(() => {
          $.ajax({
            method: "GET",
            url: url,

            success: (res) => {
              vm.searchResults = res;
            },
          });
        }, 300)();
      },
    },

    computed: {
    },

    components: {
      App,
    },

    mounted () {
    },
  });
});
