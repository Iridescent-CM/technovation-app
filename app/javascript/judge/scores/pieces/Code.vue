<template>
  <div class="mt-6">
    <p>
      <a
        :href="submission.source_code_url"
        target="_blank"
        class="text-energetic-blue text-lg flex"
        @click="trackSourceCodeDownload"
      >
        <icon name="code" color="0075cf" />
        <span class="self-center">{{ submission.source_code_url_label }} (optional)</span>
      </a>
    </p>
  </div>
</template>

<script>
import { mapState } from 'vuex'
import Icon from '../../../components/Icon'

export default {
  computed: mapState(['score', 'submission']),

  components: {
    Icon,
  },

  methods: {
    async trackSourceCodeDownload () {
      await window.axios.patch(`/judge/scores/${this.score.id}`, {submission_score: {'downloaded_source_code': true}})
    },
  },
}
</script>

