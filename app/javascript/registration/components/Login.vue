<template>
  <div
    id="login-form"
    class="panel panel--contains-bottom-bar panel--contains-top-bar"
  >
    <div class="panel__top-bar">
      Set your email & password for logging in
    </div>

    <div class="panel__content">
      <EmailInput v-model="emailComplete" />

      <PasswordInput
        v-model="password"
        @nextStepEnabled="setPasswordComplete"
      />
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
import { mapGetters, mapActions } from 'vuex'

import EmailInput from './EmailInput'
import PasswordInput from './PasswordInput'

export default {
  name: 'login',

  components: {
    EmailInput,
    PasswordInput,
  },

  data () {
    return {
      emailComplete: false,
      passwordComplete: false,
      password: '',
    }
  },

  beforeRouteEnter (_to, from, next) {
    next(vm => {
      if (vm.readyForAccount) {
        next()
      } else {
        vm.$router.replace(from.path)
      }
    })
  },

  computed: {
    ...mapGetters(['readyForAccount']),

    nextStepEnabled () {
      return this.emailComplete && this.passwordComplete
    },
  },

  methods: {
    setPasswordComplete (bool) {
      this.passwordComplete = bool
    },

    handleSubmit () {
      if (!this.nextStepEnabled) return false
      console.log('we will see')
    }
  },
}
</script>

<style lang="scss">
</style>