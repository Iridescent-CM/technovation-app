<template>
  <form
    @submit.prevent="handleSubmit"
    class="panel panel--contains-bottom-bar panel--contains-top-bar"
  >
    <div class="panel__top-bar">
      Your email address
    </div>

    <div class="panel__content">
      <EmailInput />
    </div>

    <div class="panel__bottom-bar">
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
import EmailInput from './EmailInput'

export default {
  name: 'email-validation',

  components: {
    EmailInput,
  },

  computed: {
    nextStepEnabled () {
      return false
    },
  },

  methods: {
    handleSubmit () {
      return false
    },
  },
}
</script>