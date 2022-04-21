<template>
  <div>
    <p>
      <a
          :href="`${submission.pitch_video_url}`"
          :data-opens-modal="`video-modal-${submission.pitch_video_id}`"
          :data-modal-fetch="submission.pitch_video_url"
          @click="trackPitchVideoClick"
          class="text-energetic-blue flex"
      >
        <icon name="play-circle-o" color="0075cf"/>
        Watch the pitch video
      </a>
    </p>

    <div
        class="modal"
        :id="`video-modal-${submission.pitch_video_id}`"
    >
      <div class="modal-content"></div>
    </div>
  </div>
</template>

<script>
import { mapState } from 'vuex'

import Icon from '../../../components/Icon'

export default {
  computed: mapState(['score', 'submission']),

  methods: {
    async trackPitchVideoClick (event) {
      event.preventDefault()
      await window.axios.patch(`/judge/scores/${this.score.id}`, {submission_score: {'clicked_pitch_video': true}})
    },

    async trackDemoVideoClick (event) {
      event.preventDefault()
      await window.axios.patch(`/judge/scores/${this.score.id}`, {submission_score: {'clicked_demo_video': true}})
    },
  },

  components: {
    Icon
  },
}
</script>