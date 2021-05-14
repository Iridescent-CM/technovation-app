<template>
  <div :class="solo ? 'grid__col-12' : 'grid__col-6'">

    <div class="grid grid--bleed">
      <div :class="solo ? 'grid__col-6' : 'grid__col-12'">
        <h4>Pitch</h4>
        <p>
          <a
            :href="`${submission.pitch_video_url}`"
            :data-opens-modal="`video-modal-${submission.pitch_video_id}`"
            :data-modal-fetch="submission.pitch_video_url"
            @click="trackPitchVideoClick"
          >
            <icon name="lightbulb-o" color="e6e6e5" />
            <span>Watch the pitch video</span>
          </a>
        </p>

        <div
          class="modal"
          :id="`video-modal-${submission.pitch_video_id}`"
        >
          <div class="modal-content"></div>
        </div>
      </div>

      <div :class="solo ? 'grid__col-6' : 'grid__col-12'">
        <h4>Demo Video</h4>
        <p>
          <a
            :href="`${submission.demo_video_url}`"
            :data-opens-modal="`video-modal-${submission.demo_video_id}`"
            :data-modal-fetch="submission.demo_video_url"
            @click="trackDemoVideoClick"
          >
            <icon name="film" color="e6e6e5" />
            <span>Watch the demo video</span>
          </a>
        </p>

        <div
          class="modal"
          :id="`video-modal-${submission.demo_video_id}`"
        >
          <div class="modal-content"></div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { mapState } from 'vuex'

import Icon from '../../../components/Icon'

export default {
  computed: mapState(['score', 'submission']),

  props: ['solo'],

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
    Icon,
  },
}
</script>

<style scoped>
  h4 {
    margin: 1rem 0 0;
  }

  a {
    display: flex;
    margin: 0 0 2rem;
  }

  img,
  span {
    align-self: center;
    margin-right: 0.5rem;
  }
</style>
