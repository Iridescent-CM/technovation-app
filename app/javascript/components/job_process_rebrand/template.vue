<template>
  <div class="flex flex-col items-center">
    <div :class="['mb-4 p-4 text-2xl ', statusClass]">
      <icon name="spinner" size="16" class="spin" v-if="showLoading" />
      {{ statusMsg }}
    </div>

    <div v-if="statusCode === 'complete'">
      <a class="tw-green-btn cursor-pointer" @click.stop.prevent="goBack">Back to submission</a>
    </div>
  </div>
</template>

<script>
import { urlHelpers } from 'utilities/utilities'
import Icon from '../Icon'

export default {
  components: {
    Icon,
  },

  props: {
    statusUrl: {
      type: String,
      required: true,
    }
  },

  data () {
    return {
      interval: null,
      statusCode: 'init',
    }
  },

  mounted () {
    this.interval = setInterval(() => {
      window.axios.get(this.statusUrl).then(({ data }) => {
        this.handleJSON(data)
      })
    }, 500)
  },

  destroyed () {
    clearInterval(this.interval)
  },

  computed: {
    showLoading () {
      return this.statusCode !== 'complete' && this.statusCode !== 'error'
    },

    backUrl () {
      return this.fetchGetParameterValue('back') || '/'
    },

    statusMsg () {
      switch(this.statusCode) {
        case 'init':
          return 'Creating a job for your file...'
        case 'queued':
          return 'Your file is waiting in line...'
        case 'busy':
          return 'Your file is being processed...'
        case 'error':
          return 'There was an error processing your file, please try again'
        case 'complete':
          return 'Your file is ready!'
      }
    },

    statusClass () {
      switch(this.statusCode) {
        case 'init':
          return 'yellow'
        case 'queued':
          return 'green-waiting'
        case 'busy':
          return 'green-busy'
        case 'error':
          return 'red'
        case 'complete':
          return 'green-complete'
      }
    },
  },

  methods: {
    fetchGetParameterValue: urlHelpers.fetchGetParameterValue,

    handleJSON (json) {
      this.statusCode = json.status

      if (this.statusCode === 'complete' || this.statusCode === 'error') {
        clearInterval(this.interval)
      }
    },

    goBack () {
      window.location.href = this.backUrl
    }
  },
}
</script>

<style scoped>
.yellow {
  @apply font-bold bg-lime-50
}
.green-waiting {
  @apply font-bold text-green-600
}
.green-busy {
  @apply font-bold text-green-700
}
.green-complete {
  @apply font-bold text-green-800
}
</style>