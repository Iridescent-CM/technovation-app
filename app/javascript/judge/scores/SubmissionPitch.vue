<template>
  <div class="grid__col-6 pitch">
    <h4>Pitch</h4>

    <p>
      <a
        href="#"
        :data-opens-modal="`video-modal-${submission.demo_video_id}`"
        :data-modal-fetch="submission.demo_video_url"
      >
        <icon name="film" />
        <span>Watch the demo video</span>
      </a>
    </p>

    <div
      class="modal"
      :id="`video-modal-${submission.demo_video_id}`"
    >
      <div class="modal-content"></div>
    </div>

    <p>
      <a
        href="#"
        :data-opens-modal="`video-modal-${submission.pitch_video_id}`"
        :data-modal-fetch="submission.pitch_video_url"
      >
        <icon name="lightbulb-o" />
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
</template>

<script>
import { mapState } from 'vuex'

import Icon from '../../components/Icon'

export default {
  computed: mapState(['submission']),

  components: {
    Icon,
  },
}
</script>

<style scoped>
  a {
    display: flex;
  }

  img,
  span {
    align-self: center;
    margin-right: 1rem;
  }
</style>
