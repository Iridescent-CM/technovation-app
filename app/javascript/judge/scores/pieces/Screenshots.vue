<template>
  <div
    id="screenshots-nav"
    class="flex flex-row flex-wrap gap-4 justify-center"
    :data-modal-last="submission.screenshots.length - 1"
  >
    <div
      v-for="(screenshot, i) in submission.screenshots"
      :key="screenshot.id"
      class="mx-2 w-1/2 lg:w-1/4"
    >
      <img
        class="judge-screenshot-modal rounded object-cover w-full h-full"
        :src="screenshot.thumb"
        :data-modal-url="screenshot.full"
        :data-modal-idx="i"
      />
    </div>
  </div>
</template>

<script>
import { mapState } from 'vuex'

export default {
  computed: mapState(['submission']),
}
</script>
