<template>
  <div class="certificate-button">
    <div
      v-if="isLoading"
      class="button button--reward button--disabled"
    >
      <icon
        v-if="isLoading"
        class="spin"
        name="spinner"
        color="ffffff"
        size="16"
      />

      <span>{{ getStateText }}</span>
    </div>

    <a
      v-else
      ref="certificateButton"
      class="button button--reward"
      target="_blank"
      :href="fileUrl"
    >Open your certificate</a>
  </div>
</template>

<script>
import Icon from './Icon.vue'

export default {
  name: 'certificate-button',

  components: {
    Icon,
  },

  data () {
    return {
      fileUrl: null,
      jobId: null,
      state: 'requesting',
    }
  },

  props: {
    teamId: {
      type: Number,
      default: 0,
    },

    userScope: {
      type: String,
      required: true,
      validator (value) {
        return [
          'mentor',
          'student',
          'judge'
        ].includes(value)
      }
    },
  },

  created () {
    this.requestCertificate()
  },

  computed: {
    getStateText () {
      const capitalizedState = this.state.charAt(0).toUpperCase() + this.state.slice(1);

      return `${capitalizedState} certificate...`
    },

    isLoading () {
      return this.state !== 'ready'
    },

    jobMonitorUrl () {
      return `/${this.userScope}/job_statuses/${this.jobId}`
    },

    certificateRequestData () {
      if (Boolean(this.teamId)) {
        return { team_id: this.teamId }
      } else {
        return {}
      }
    },
  },

  methods: {
    requestCertificate () {
      this.state = 'requesting'

      return window.axios.post(
        `/${this.userScope}/certificates/`,
         this.certificateRequestData
      )
      .then((response) => {
        this.handleJobRequest(response).then(this.pollJobQueue)
      })
    },

    handleJobRequest (response) {
      return new Promise((resolve, _reject) => {
        if (Boolean(response.data.jobId)) {
          this.jobId = response.data.jobId
          this.state = 'generating'
        } else if (response.data.status === 'complete') {
          this.makeReady(response)
        }

        resolve()
      })
    },

    pollJobQueue () {
      if (this.isLoading) {
        window.axios.get(this.jobMonitorUrl).then(this.handlePollRequest)
      }
    },

    handlePollRequest (response) {
      if (response.data.status === 'queued') {
        this.pollJobQueue()
      } else if (response.data.status === 'complete') {
        this.makeReady(response)
      }
    },

    makeReady (response) {
      this.state = 'ready'
      this.fileUrl = response.data.payload.fileUrl
    },
  },
}
</script>

<style scoped>
  .button span {
    display: inline-block;
    padding-left: 0.25rem;
  }
</style>