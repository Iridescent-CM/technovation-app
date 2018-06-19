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
import axios from 'axios'
import Icon from './Icon.vue'

const csrfTokenMetaTag = document.querySelector('meta[name="csrf-token"]')

if (csrfTokenMetaTag) {
  axios.defaults.headers.common = {
    'X-Requested-With': 'XMLHttpRequest',
    'X-CSRF-TOKEN' : csrfTokenMetaTag.getAttribute('content')
  }
}

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
    this.createJob().then((response) => {
      this.pollJobQueue()
    })
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
    createJob () {
      this.state = 'generating'

      return axios.post(
        `/${this.userScope}/certificates/`,
         this.certificateRequestData
      ).then(this.handleJobRequest)
    },
    handleJobRequest (response) {
      if (Boolean(response.data.jobId)) {
        this.jobId = response.data.jobId
      } else if (response.data.status === 'complete') {
        this.makeReady(response)
      }
    },
    pollJobQueue () {
      axios.get(this.jobMonitorUrl)
        .then(this.handleGenerationRequest)
    },
    handleGenerationRequest (response) {
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