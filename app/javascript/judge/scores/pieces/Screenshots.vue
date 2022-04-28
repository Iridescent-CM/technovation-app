<template>
  <div
    id="screenshots-nav"
    class="flex flex-row flex-nowrap max-w-full"
    :data-modal-last="submission.screenshots.length - 1"
  >

    <div
      v-for="(screenshot, i) in submission.screenshots"
      :key="screenshot.id"
      class="submission-pieces__screenshot"
    >
      <img
        class="img-modal"
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
