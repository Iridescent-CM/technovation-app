import TurbolinksAdapter from 'vue-turbolinks';
import VueDragula from 'vue-dragula';
import Vue from 'vue/dist/vue.esm'
import App from '../app.vue'

Vue.use(TurbolinksAdapter)
Vue.use(VueDragula)

document.addEventListener('turbolinks:load', () => {
  const screenshotsUrl = $("#screenshots").data("url"),
        teamId = $("#screenshots").data("team-id");

  const app = new Vue({
    el: '#app',
    data: {
      maxAllowed: 6,
      screenshots: [],
      uploads: [],
    },

    computed: {
      maxFiles () {
        return this.maxAllowed - this.screenshots.length;
      },

      object () {
        return this.maxFiles != 1 ? "screenshots" : "screenshot";
      },

      prefix () {
        return this.maxFiles != 1 ? "up to" : "";
      },
    },

    methods: {
      removeScreenshot (screenshot) {
        swal({
          text: "Are you sure you want to delete the screenshot?",
          cancelButtonText: "No, go back",
          confirmButtonText: "Yes, delete it",
          confirmButtonColor: "#D8000C",
          showCancelButton: true,
          reverseButtons: true,
          focusCancel: true,
        }).then(
          () => {
            var idx = this.screenshots.indexOf(screenshot);
            this.screenshots.splice(idx, 1);
            $.ajax({
              method: "DELETE",
              url: screenshotsUrl + "/" + screenshot.id,
            });
          },

          () => { return false; }
        );
      },

      handleFileInput (e) {
        var keep = [].slice.call(e.target.files, 0, this.maxFiles),
            vm = this;

        [].forEach.call(keep, (file) => {
          this.uploads.push(file);

          var vm = this,
              form = new FormData();

          form.append(
            "team_submission[screenshots_attributes][]image", file
          );

          form.append("team_id", teamId);

          $.ajax({
            method: "POST",
            url: screenshotsUrl,
            data: form,
            contentType: false,
            processData: false,
            success: (data) => {
              vm.screenshots.push({
                id: data.id,
                src: data.src,
                name: data.name,
                large_img_url: data.large_img_url,
              });

              var i = vm.uploads.indexOf(file);
              vm.uploads.splice(i, 1);

              e.target.value = "";
            },
          });
        });
      },
    },

    components: {
      App,
    },

    mounted () {
      var vm = this;

      $.ajax({
        method: "GET",
        url: screenshotsUrl,
        success: function(data) {
          vm.screenshots = data;
        },
      });

      Vue.vueDragula.eventBus.$on('drop', (args) => {
        var dropped = args[1],
            list = args[2];

        var url = $(list).data("sort-url"),
            items = $(list).find(".sortable-list__item"),
            form = new FormData();

        [].forEach.call(items, (item) => {
          form.append(
            "team_submission[screenshots][]",
            $(item).data("db-id")
          );
        });

        form.append("team_id", teamId);

        $.ajax({
          method: "PATCH",
          url: url,
          data: form,
          contentType: false,
          processData: false,
          success: function() {
            if (window.timeout) {
              clearTimeout(window.timeout);
              window.timeout = null;
            }

            $(dropped).addClass("sortable-list--updated");

            window.timeout = setTimeout(function () {
              $(dropped).removeClass("sortable-list--updated");
            }, 100);
          },
        });
      });
    },
  })
})
