<template>
  <review-region-requests
    :requests="declinedRequests"
    request-status="declined"
  />
</template>

<script>
import { mapState } from 'vuex'

import ReviewRegionRequests from './ReviewRegionRequests'

export default {
  components: {
    ReviewRegionRequests,
  },

  computed: {
    ...mapState(['allRequests']),

    declinedRequests () {
      return this.allRequests.filter(r => r.isDeclined())
    },
  },
}
</script>

<style lang="scss" scoped>
</style>