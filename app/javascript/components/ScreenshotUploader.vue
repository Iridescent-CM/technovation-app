<template>
  <div id="screenshot-uploader">
    <template v-if="maxFiles > 0">
      <p class="margin--b-xlarge">
        You must submit at least 2 images.
        Upload 2-6 images that showcase your Technovation journey.
        They should help judges better understand your ideas.
      </p>

      <label>
        <input
          type="file"
          multiple
          @change="handleFileInput"
          id="attach-screenshots"
          style="display: none;"
        />

        <span class="button button--small">
          + Add {{ prefix }} {{ maxFiles }} {{ object }}
        </span>
      </label>
    </template>

    <template v-else>
      You have uploaded the maximum of {{ maxAllowed }} images.
      You need to remove some if you want to add others.
    </template>

    <div v-if="uploadsHaveErrors" class="flash flash--alert">
      <span
        class="icon-close icon--red"
        @click.prevent="resetErrors"
      ></span>
      Sorry, you tried to upload an invalid file type.
    </div>

    <p v-if="screenshots.length > 1">
      Sort your images in the order that you want
      the judges to see them:
    </p>

    <ol
      v-dragula
      id="sortable-list"
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
          :data-modal-url="screenshot.largeImgUrl"
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
export default {
  name: 'screenshot-uploader',

  data () {
    return {
      maxAllowed: 6,
      screenshots: [],
      uploads: [],
      uploadsHaveErrors: false,
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
    resetErrors () {
      this.uploadsHaveErrors = false
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

      window.axios.delete(url);
    },

    handleFileInput (e) {
      this.uploadsHaveErrors = false

      const keep = [].slice.call(e.target.files, 0, this.maxFiles).filter(i => {
        return i.type.match(/image\/(?:jpe?g|gif|png)/)
      })

      const discard = [].slice.call(e.target.files, 0, this.maxFiles).filter(i => {
        return !i.type.match(/image\/(?:jpe?g|gif|png)/)
      })

      if (discard.length)
        this.uploadsHaveErrors = true

      keep.forEach((file) => {
        this.uploads.push(file)

        const form = new FormData()
        form.append("team_submission[screenshots_attributes][]image", file)
        form.append("team_id", this.teamId)

        window.axios.post(this.screenshotsUrl, form)
          .then(({data}) => {
            this.screenshots.push(data)

            const i = this.uploads.indexOf(file)
            this.uploads.splice(i, 1)

            e.target.value = ""
          })
      })
    },
  },
}
</script>

<style scoped>
</style>
