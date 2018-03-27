<template>
  <div :class="team.live_event ? 'grid__col-6' : 'grid__col-12'">
    <h4>Business</h4>

    <template v-if="team.division === 'senior'">
      <a :href="submission.business_plan_url" target="_blank">
        Read the business plan
      </a>
    </template>

    <template v-else>
      Junior Division teams do not upload a business plan.
    </template>
  </div>
</template>

<script>
import { mapState } from 'vuex'

export default {
  computed: mapState(['team', 'submission']),
}
</script>
