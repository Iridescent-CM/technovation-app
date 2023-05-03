<template>
  <div>
    <p>
      <a
        :href="`${submission.pitch_video_url}`"
        :data-opens-modal="`video-modal-${submission.pitch_video_id}`"
        :data-modal-fetch="submission.pitch_video_url"
        class="text-energetic-blue flex text-3xl"
      >
        <Icon name="play-circle-o" color="0075cf"/>
        Watch the pitch video
      </a>
    </p>

    <div
      class="modal"
      :id="`video-modal-${submission.pitch_video_id}`"
      data-width="700px"
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

  components: {
    Icon
  },
}
</script>
