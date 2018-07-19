<template>
  <form>
    <label for="email">Email Address</label>
    <input
      type="email"
      id="email"
      autocomplete="email"
      v-model="email"
    />
  </form>
</template>

<script>
import debounce from 'lodash/debounce'

export default {
  name: 'email-validation',

  data () {
    return {
      email: '',
      validationStatus: 'pending',
      isDisposableAddress: false,
      didYouMean: null,
      mailboxVerification: null,
      isValidating: false,
    }
  },

  created () {
    this.debouncedEmailWatcher = debounce(this.validateEmailInput, 500)
  },

  watch: {
    email () {
      this.debouncedEmailWatcher()
    },
  },

  methods: {
    validateEmailInput () {
      if (!this.email.length || this.isValidating) return false

      this.isValidating = true

      axios.get(`/validate_email?address=${encodeURIComponent(this.email)}`)
        .then(({ data }) => {
          this.isValidating = false
          this.validationStatus = data.is_valid
          this.isDisposableAddress = data.is_disposable_address
          this.didYouMean = data.did_you_mean
          this.mailboxVerification = data.mailbox_verification === "true"
        }).catch(err => {
          this.isValidating = false
          console.error(err)
        })
    },
  },
}
</script>