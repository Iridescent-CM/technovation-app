<template>
  <review-region-requests
    :requests="approvedRequests"
    request-status="approved"
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

    approvedRequests () {
      return this.allRequests.filter(r => r.isApproved())
    },
  },
}
</script>

<style lang="scss" scoped>
</style>