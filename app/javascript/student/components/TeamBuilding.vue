<template>
  <form class="panel panel--contains-bottom-bar panel--contains-top-bar">
    <div class="panel__top-bar">
      Part 2: Team building
    </div>

    <div class="panel__content">
      Hello world
    </div>

    <div class="panel__bottom-bar">
      <a
        class="button float--left"
        @click.prevent="navigateBack"
      >
        Back
      </a>
      <button
        class="button"
        :disabled="!nextStepEnabled"
        @click.prevent="handleSubmit"
      >
        Next
      </button>
    </div>
  </form>
</template>

<script>
import { mapGetters, mapActions, mapState } from 'vuex'

export default {
  beforeRouteEnter (_to, _from, next) {
    next(vm => {
      // need to check something with vm first?
      next()
    })
  },

  computed: {
    ...mapState([]),

    ...mapGetters([]),

    nextStepEnabled () {
      true
    },
  },

  watch: {
  },

  methods: {
    ...mapActions([]),

    handleSubmit () {
      if (!this.nextStepEnabled) return false
      console.log("[TRIPLE LINDI]", "well? we're waiting...")
    },

    navigateBack () {
      console.warn("[wat]", "wat")
    },
  },
}
</script>

<style lang="scss" scoped>
</style>