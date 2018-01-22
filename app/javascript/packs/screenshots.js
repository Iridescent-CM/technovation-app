import TurbolinksAdapter from 'vue-turbolinks';
import Vue from 'vue/dist/vue.esm'
import App from '../app.vue'

Vue.use(TurbolinksAdapter)

document.addEventListener('turbolinks:load', () => {
  const screenshotsUrl = $("#screenshots").data("url");

  const app = new Vue({
    el: '#app',
    data: {
      maxAllowed: 6,
      screenshots: [],
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

        Array.prototype.forEach.call(keep, (file) => {
          readAndPreview(file);
          upload(file);
        });

        function upload (file) {
          var form = new FormData();
          form.append(
          "team_submission[screenshots_attributes][]image", file
          );

          $.ajax({
            method: "POST",
            url: screenshotsUrl,
            data: form,
            contentType: false,
            processData: false,
            success: (data) => {
              e.target.value = "";
              return false;
            },
          });
        }

        function readAndPreview (file) {
          var reader = new FileReader();

          reader.onload = evt => {
            vm.screenshots.push({
              src: evt.target.result,
              name: file.name,
            });
          };

          reader.readAsDataURL(file);
        }
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
    },
  })
})
