<template>
  <div
    id="login-form"
    class="panel panel--contains-bottom-bar panel--contains-top-bar"
  >
    <div class="panel__top-bar">
      Set your email & password for logging in
    </div>

    <div class="panel__content">
      <EmailInput />
      <PasswordInput />
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
  </div>
</template>

<script>
import EmailInput from './EmailInput'
import PasswordInput from './PasswordInput'

export default {
  name: 'login',

  components: {
    EmailInput,
    PasswordInput,
  },

  computed: {
    nextStepEnabled () {
      return false
    },
  },

  methods: {
    handleSubmit () {
      if (!this.nextStepEnabled) return false
      console.log('we will see')
    }
  },
}
</script>

<style lang="scss">
</style>