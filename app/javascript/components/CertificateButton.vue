<template>
  <div class="certificate-button">
    <template v-if="isLoading">
      <icon
        v-if="isLoading"
        class="spin"
        name="spinner"
      />
      <span>{{ getStateText }}</span>
    </template>
    <a
      v-else
      ref="certificateButton"
      class="button"
      :href="fileUrl"
    >Open your certificate</a>
  </div>
</template>

<script>
import axios from 'axios'
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
    createJobUrl () {
      if (Boolean(this.teamId)) {
        return `/${this.userScope}/certificates/${this.teamId}`
      }
      return `/${this.userScope}/certificates/`
    },
  },
  methods: {
    createJob () {
      this.state = 'generating'
      return axios.post(this.createJobUrl)
        .then(this.handleJobRequest)
    },
    handleJobRequest (response) {
      if (Boolean(response.jobId)) {
        this.jobId = response.jobId
      }
    },
    pollJobQueue () {
      axios.get(this.jobMonitorUrl)
        .then(this.handleGenerationRequest)
    },
    handleGenerationRequest (response) {
      if (response.status === 'queued') {
        this.pollJobQueue()
      } else if (response.status === 'complete') {
        this.state = 'ready'
        // TODO - Instead of setting the state to ready here, we should make a
        // third request to fetch the fileUrl, which we then set via a function
      }
    },
  },
}
</script>
