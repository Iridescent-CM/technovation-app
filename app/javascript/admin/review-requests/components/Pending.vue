<template>
  <review-region-requests
    :requests="pendingRequests"
    request-status="pending"
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

    pendingRequests () {
      return this.allRequests.filter(r => r.isPending())
    },
  },
}
</script>

<style lang="scss" scoped>
</style>