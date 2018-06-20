<template>
  <div id="screenshot-uploader">
    <template v-if="maxFiles > 0">
      <label class="label--wraps-file-input">
        <input type="file" multiple @change="handleFileInput" />

        <span class="button button--small">
          + Add {{ prefix }} {{ maxFiles }} {{ object }}
        </span>
      </label>
    </template>

    <template v-else>
      You have uploaded the maximum of {{ maxAllowed }} screenshots.
      You need to remove some if you want to add others.
    </template>

    <p v-if="screenshots.length > 1">
      Sort your screenshots in the order that you want
      the judges to see them:
    </p>

    <ol
      v-dragula
      id="sortable-list"
      data-sort-url="sortUrl"
      class="sortable-list submission-pieces__screenshots"
    >
      <li
        class="sortable-list__item draggable"
        v-for="screenshot in screenshots"
        :key="screenshot.id"
        :data-db-id="screenshot.id"
      >
        <img
          class="submission-pieces__screenshot img-modal"
          :src="screenshot.src"
          :alt="screenshot.name"
          :data-modal-url="screenshot.large_img_url"
        />

        <div class="sortable-list__item-actions">
          <i
            class="icon-remove icon--red"
            @click="removeScreenshot(screenshot)"
          ></i>
        </div>
      </li>

      <li
        class="submission-pieces__screenshot-placeholder"
        v-for="upload in uploads"
        :key="upload.id"
      >
        <i class="icon-spinner2 spin"></i>
        <span>{{ upload.name }}</span>
      </li>
    </ol>
  </div>
</template>

<script>
import Vue from 'vue'
import VueDragula from 'vue-dragula';

Vue.use(VueDragula)

export default {
  name: 'screenshot-uploader',

  props: {
    sortUrl: {
      type: String,
      required: true,
    },

    screenshotsUrl: {
      type: String,
      required: true,
    },

    teamId: {
      type: Number,
      required: true,
    },
  },

  data () {
    return {
      maxAllowed: 6,
      screenshots: [],
      uploads: [],
    }
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
            url: this.screenshotsUrl +
                  "/" +
                  screenshot.id +
                  "?team_id=" +
                  this.teamId,
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

        form.append("team_id", this.teamId);

        $.ajax({
          method: "POST",
          url: this.screenshotsUrl,
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

  mounted () {
    var vm = this;

    $.ajax({
      method: "GET",
      url: this.screenshotsUrl + "?team_id=" + this.teamId,
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

      form.append("team_id", this.teamId);

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
}
</script>

<style scoped>
</style>