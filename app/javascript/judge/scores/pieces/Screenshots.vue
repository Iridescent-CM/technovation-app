<template>
  <div
    id="screenshots-nav"
    class="flex flex-col lg:flex-row flex-wrap"
    :data-modal-last="submission.screenshots.length - 1"
  >
    <div
      v-for="(screenshot, i) in submission.screenshots"
      :key="screenshot.id"
      class="w-full lg:w-1/3 h-64 p-4 flex flex-col justify-center items-center"
    >
      <img
        class="judge-screenshot-modal object-cover h-full w-full rounded"
        :src="filestackResizeUrl(screenshot.full)"
        :data-modal-url="screenshot.full"
        :data-modal-idx="i"
      />
    </div>
  </div>
</template>

<script>
import { mapState } from 'vuex'
import {getFilestackResizeUrl} from "../../../utilities/filestack-helpers";

export default {
  computed: mapState(['submission']),
  methods: {
    filestackResizeUrl(screenshotUrl) {
      return getFilestackResizeUrl(screenshotUrl, 300)
    }
  }
}
</script>
