<template>
  <div :class="team.live_event ? 'grid__col-6' : 'grid__col-12'">
    <p class="font-bold">Business</p>

    <template v-if="team.division === 'senior' || team.division ===  'junior'">
      <a
        :href="submission.business_plan_url"
        target="_blank"
        @click="trackBusinessPlanDownload"
        class="text-energetic-blue font-bold"
      >
        <Icon
            size="16"
            name="file-o"
            class="inline"
            color="0075cf"
        />
        Read the <span>{{ documentType }}</span> plan
      </a>
    </template>

    <template v-else>
      Beginner Division teams do not upload a business plan.
    </template>
  </div>
</template>

<script>
import { mapState } from 'vuex'
import Icon from "../../../components/Icon";

export default {
  computed: {
    ...mapState(['score', 'submission', 'team']),

    documentType () {
      switch (this.team.division) {
        case 'senior':
          return 'business'
          break
        case 'junior':
          return 'user adoption'
          break
      }
    }
  },
  components: {
    Icon
  },
  methods: {
    async trackBusinessPlanDownload () {
      await window.axios.patch(`/judge/scores/${this.score.id}`, {submission_score: {'downloaded_business_plan': true}})
    },
  },
}
</script>
