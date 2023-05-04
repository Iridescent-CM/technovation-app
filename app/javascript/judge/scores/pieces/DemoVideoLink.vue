<template>
  <div>
    <p>
      <a
        :href="`${submission.demo_video_url}`"
        :data-opens-modal="`video-modal-${submission.demo_video_id}`"
        :data-modal-fetch="submission.demo_video_url"
        class="text-energetic-blue flex text-3xl"
      >
        <icon name="play-circle-o" color="0075cf"/>
        Watch the {{ demo_video() }}
      </a>
    </p>

    <div
      class="modal"
      :id="`video-modal-${submission.demo_video_id}`"
      data-width="700px"
    >
      <div class="modal-content"></div>
    </div>
  </div>
</template>

<script>
import {mapState} from 'vuex'

import Icon from '../../../components/Icon'
import { i18n } from '../../../utilities/i18n.js'

export default {
  computed: mapState(['score', 'submission']),

  components: {
    Icon
  },

  methods: {
    demo_video() {
      return i18n.t("submissions.demo_video")
    }
  }
}
</script>
