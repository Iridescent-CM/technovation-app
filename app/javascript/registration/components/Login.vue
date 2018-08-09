<template>
  <form
    id="login-form"
    class="panel panel--contains-bottom-bar panel--contains-top-bar"
    action="/registration/account"
    method="post"
  >
    <input type="hidden" name="account[wizard_token]" :value="wizardToken" />

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
        class="button float--left"
        @click.prevent="navigateBack"
      >
        Back
      </button>
      <button
        class="button"
        type="submit"
        :disabled="!nextStepEnabled"
      >
        Next
      </button>
    </div>
  </form>
</template>

<script>
import { mapGetters, mapState } from 'vuex'

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
    ...mapState(['wizardToken']),
    ...mapGetters(['readyForAccount']),

    nextStepEnabled () {
      return this.emailComplete && this.passwordComplete
    },
  },

  methods: {
    setPasswordComplete (bool) {
      this.passwordComplete = bool
    },

    navigateBack () {
      this.$router.push({ name: 'basic-profile' })
    },
  },
}
</script>

<style lang="scss">
</style>