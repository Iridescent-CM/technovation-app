<template>
  <div>
    <p>
      <a
        :href="`${submission.pitch_video_url}`"
        :data-opens-modal="`video-modal-${submission.pitch_video_id}`"
        :data-modal-fetch="submission.pitch_video_url"
        class="text-energetic-blue flex text-3xl"
      >
        <AppIcon name="play-circle-o" color="0075cf" />
        Watch the pitch video
      </a>
    </p>

    <div
      :id="`video-modal-${submission.pitch_video_id}`"
      class="modal"
      data-width="700px"
    >
      <div class="modal-content"></div>
    </div>
  </div>
</template>

<script>
import { mapState } from "vuex";

import AppIcon from "../../../components/AppIcon";

export default {
  components: {
    AppIcon,
  },

  computed: mapState(["score", "submission"]),
};
</script>
