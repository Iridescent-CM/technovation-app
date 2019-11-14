<template>
  <div :class="solo ? 'grid__col-12' : 'grid__col-6'">
    <h4>Pitch</h4>

    <div class="grid grid--bleed">
      <div :class="solo ? 'grid__col-6' : 'grid__col-12'">
        <p>
          <a
            href="#"
            :data-opens-modal="`video-modal-${submission.pitch_video_id}`"
            :data-modal-fetch="submission.pitch_video_url"
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
    </div>
  </div>
</template>

<script>
import { mapState } from 'vuex'

import Icon from '../../../components/Icon'

export default {
  computed: mapState(['submission']),

  props: ['solo'],

  components: {
    Icon,
  },
}
</script>

<style scoped>
  h4 {
    margin: 0 0 1rem;
  }

  a {
    display: flex;
  }

  img,
  span {
    align-self: center;
    margin-right: 1rem;
  }
</style>
