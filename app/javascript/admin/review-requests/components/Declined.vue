<template>
  <review-region-requests
    :requests="declinedRequests"
    request-status="declined"
    action-btn-txt="Change"
    list-title="Requested"
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