<template>
  <div>
    <div :class="['status', statusClass]">
      <icon name="spinner" size="16" class="spin" v-if="showLoading" />
      {{ statusMsg }}
    </div>

    <p v-if="statusCode === 'complete'">
      <a class="button" @click.stop.prevent="goBack">Okay</a>
    </p>
  </div>
</template>

<script>
import { fetchGetParameterValue } from 'utilities/utilities'
import Icon from '../Icon'

export default {
  data () {
    return {
      interval: null,
      statusCode: 'init',
    }
  },

  props: ['statusUrl'],

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
          return "Creating a job for your file..."
        case 'queued':
          return "Your file is waiting in line..."
        case 'busy':
          return "Your file is being processed..."
        case 'complete':
          return "Your file is ready!"
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
    fetchGetParameterValue,

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

  mounted () {
    this.interval = setInterval(() => {
      window.axios.get(this.statusUrl).then(({ data }) => {
        this.handleJSON(data)
      })
    }, 500)
  },

  components: {
    Icon,
  },
}
</script>

<style scoped>
.status {
  margin: 1rem 0;
  padding: 1rem;
}
.yellow {
  background: rgba(246, 252, 187, 1);
}
.green-waiting {
  background: rgba(69, 181, 82, 0.5);
}
.green-busy {
  background: rgba(69, 181, 82, 0.75);
}
.green-complete {
  background: rgba(69, 181, 82, 1);
}
</style>