<template>
  <div id="screenshot-uploader">
    <template v-if="maxFiles > 0">
      <p class="margin--b-xlarge">
        You must submit at least 2 images.
        Upload 2-6 images that showcase your Technovation journey.
        They should help judges better understand your ideas.
      </p>

      <button @click="uploadFile" class="button button--small">
        + Add {{ prefix }} {{ maxFiles }} {{ object }}
      </button>
    </template>

    <template v-else>
      You have uploaded the maximum of {{ maxAllowed }} images.
      You need to remove some if you want to add others.
    </template>

    <p v-if="screenshots.length > 1">
      Sort your images in the order that you want
      the judges to see them:
    </p>

    <ol
      v-dragula
      id="sortable-list"
      class="submission-pieces__screenshots"
    >
      <li
        class="sortable-list__item draggable screenshot-wrapper"
        v-for="screenshot in screenshots"
        :key="screenshot.id"
        :data-db-id="screenshot.id"
      >
        <img
          class="submission-pieces__screenshot img-modal"
          :src="screenshot.src"
          alt="Screenshot"
          :data-modal-url="screenshot.src"
        />

        <div class="sortable-list__item-actions">
          <i
            class="icon-remove icon--red"
            @click="removeScreenshot(screenshot)"
          ></i>
        </div>
      </li>
    </ol>
  </div>
</template>

<script>
import * as filestack from 'filestack-js';
export default {
  name: 'screenshot-uploader',

  data () {
    return {
      maxAllowed: 6,
      screenshots: [],
    }
  },

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

    teamSubmissionId: {
      type: Number,
      required: true,
    },
  },

  mounted () {
    var vm = this;

    this.loadScreenshots()

    window.vueDragula.eventBus.$on('drop', (args) => {
      const dropped = args[1]
      const list = args[2]

      const url = this.sortUrl
      const sortableItems = list.querySelectorAll('.sortable-list__item')
      const form = new FormData()

      sortableItems.forEach((item) => {
        form.append(
          "team_submission[screenshots][]",
          item.dataset.dbId
        )
      })

      form.append("team_id", this.teamId)

      window.axios.patch(url, form)
        .then(() => {
          if (window.timeout) {
            clearTimeout(window.timeout)
            window.timeout = null
          }

          dropped.classList.add('sortable-list--updated')

          window.timeout = setTimeout(() => {
            dropped.classList.remove('sortable-list--updated')
          }, 100)
        })
    })
  },

  computed: {
    maxFiles () {
      return this.maxAllowed - this.screenshots.length
    },

    object () {
      return this.maxFiles > 1 ? "images" : "image"
    },

    prefix () {
      return this.maxFiles > 1 ? "up to" : ""
    },
  },

  methods: {
    uploadFile() {
      const client = filestack.init(process.env.FILESTACK_API_KEY);
      const TWO_MB_FILE_SIZE = 2 * 1024 * 1024

      const fsPickerOptions = {
        accept: ["image/jpeg", "image/jpg", "image/png"],
        maxSize: TWO_MB_FILE_SIZE,
        fromSources: ["local_file_system"],
        maxFiles: this.maxFiles,
        storeTo: {
          location: "s3",
          container: process.env.AWS_BUCKET_NAME,
          path: "uploads/screenshot/filestack/" + this.teamSubmissionId + "/",
          region: "us-east-1"
        },
        onFileSelected: (file) => {
          if (file.size > TWO_MB_FILE_SIZE) {
            throw new Error("Image is too large. Please select a photo under 2MB.");
          }
        },
        onFileUploadFinished: (file) => {
          const form = new FormData();
          form.append("team_id", this.teamId)
          form.append("team_submission[image]", file.url)

          window.axios.post(this.screenshotsUrl, form)
            .then(({data}) => {
              this.screenshots.push(data)
            })
        }
      };

      client.picker(fsPickerOptions).open();
    },

    loadScreenshots () {
      window.axios.get(`${this.screenshotsUrl}?team_id=${this.teamId}`)
        .then(({data}) => {
          this.screenshots = data
        })
    },

    removeScreenshot (screenshot) {
      swal({
        text: "Are you sure you want to delete the image?",
        cancelButtonText: "No, go back",
        confirmButtonText: "Yes, delete it",
        confirmButtonColor: "#D8000C",
        showCancelButton: true,
        reverseButtons: true,
        focusCancel: true,
      }).then((result) => {
        if (result.value) {
          this.handleAlertConfirmation(screenshot)
        }
      })
    },

    handleAlertConfirmation (screenshot) {
      const index = this.screenshots.indexOf(screenshot);
      this.screenshots.splice(index, 1);

      const url = this.screenshotsUrl +
                  `/${screenshot.id}?team_id=${this.teamId}`

      window.axios.delete(url)
        .then(() => {
          window.location.reload()
        })
    },
  },
}
</script>