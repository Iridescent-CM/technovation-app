<template>
  <form>
    <template v-if="!validationPending">
      <div
        class="flash flash--alert"
        v-if="emailIsInvalid"
      >
        Sorry, the email address you typed appears to be invalid.
      </div>

      <div
        class="flash flash--alert"
        v-if="emailIsTaken"
      >
        That email is taken. Try
        <a
          class="cursor--pointer text-decoration--underline"
          :href="`/signin?email=${this.email}`"
        >
          signing in
        </a>
        instead.
      </div>

      <div
        class="flash flash--alert"
        v-if="isDisposableAddress"
      >
        You cannot use a disposable email address.
      </div>

      <div
        class="flash font-weight--bold"
        v-if="didYouMean"
      >
        Did you mean
        <span
          class="cursor--pointer text-decoration--underline"
          @click="handleDidYouMean"
        >
          {{ didYouMean }}
        </span>
        ?
      </div>
    </template>

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
      isValidating: false,
      validationStatus: 'pending',
      isDisposableAddress: false,
      didYouMean: null,
      mailboxVerification: null,
      emailIsTaken: null,
    }
  },

  created () {
    this.debouncedEmailWatcher = debounce(this.validateEmailInput, 700)
  },

  computed: {
    validationPending () {
      return this.isValidating || this.validationStatus === 'pending'
    },

    emailIsInvalid () {
      return !this.validationPending && !this.validationStatus || !this.mailboxVerification
    },
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
          this.emailIsTaken = data.is_taken
        }).catch(err => {
          this.isValidating = false
          console.error(err)
        })
    },

    handleDidYouMean () {
      this.validationStatus = 'pending'
      this.email = this.didYouMean
    },
  },
}
</script>