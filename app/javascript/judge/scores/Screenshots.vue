<template>
  <div class="submission-pieces__screenshots">
    <div
      v-for="screenshot in submission.screenshots"
      class="submission-pieces__screenshot"
    >
      <img
        class="img-modal"
        :src="screenshot.thumb"
        :data-modal-url="screenshot.full"
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
