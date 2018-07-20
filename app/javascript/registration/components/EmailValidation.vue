<template>
  <form>
    <p>
      We need an email address that you can be contacted at, and we will
      <strong>only</strong> use it to send you important updates to help
      you do your best during the season.
    </p>

    <p class="font-style--italic">
      We do not work with marketers or advertisers in any form whatsoever.
    </p>

    <label for="email">Email Address</label>

    <input
      type="email"
      id="email"
      autocomplete="email"
      placeholder="example: janie.doe@gmail.com"
      v-model="email"
    />

    <p class="hint">
      Please choose a personal, permanent email.
      A school or company email might block us from
      sending important messages to you.
    </p>

    <div
      v-if="emailNeedsValidation"
      class="text-align--center"
    >
      Checking this email...<br />
      <icon name="spinner" class="spin" />
    </div>

    <template v-if="problemsWithInput">
      <div class="padding--t-b-small font-weight--bold color--alert">
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

    <div
      v-if="nextStepEnabled"
      class="flash flash--success"
    >
      Your email looks good! You're ready for the next step!
    </div>

    <div class="text-align--right">
      <button
        class="button"
        :disabled="!nextStepEnabled"
      >
        Next
      </button>
    </div>
  </form>
</template>

<script>
import Icon from '../../components/Icon'
import debounce from 'lodash/debounce'

export default {
  name: 'email-validation',

  components: {
    Icon,
  },

  data () {
    return {
      email: '',
      emailNeedsValidation: false,
      emailHasBeenChecked: false,
      emailIsValid: false,
      emailIsTaken: false,
      isDisposableAddress: false,
      mailboxVerification: false,
      didYouMean: null,
    }
  },

  created () {
    this.debouncedEmailWatcher = debounce(this.validateEmailInput, 750)
  },

  computed: {
    problemsWithInput () {
      return this.emailHasBeenChecked && (
              !this.emailIsValid ||
                this.emailIsTaken ||
                  this.isDisposableAddress
              )
    },

    nextStepEnabled () {
      return this.emailHasBeenChecked && !this.problemsWithInput
    }
  },

  watch: {
    email () {
      if (this.email.length) {
        this.emailHasBeenChecked = false
        this.emailNeedsValidation = true
        this.debouncedEmailWatcher()
      } else {
        this.reset()
      }
    },
  },

  methods: {
    validateEmailInput () {
      axios.get(`/validate_email?address=${encodeURIComponent(this.email)}`)
        .then(({ data }) => {
          this.emailHasBeenChecked = true
          this.emailNeedsValidation = false

          this.emailIsValid = data.is_valid
          this.isDisposableAddress = data.is_disposable_address
          this.didYouMean = data.did_you_mean
          this.mailboxVerification = data.mailbox_verification === "true"
          this.emailIsTaken = data.is_taken
        }).catch(err => {
          console.error(err)
        })
    },

    handleDidYouMean () {
      this.emailNeedsValidation = false
      this.emailHasBeenChecked = false
      this.email = this.didYouMean
    },

    reset () {
      this.email = ''
      this.emailNeedsValidation = false
      this.emailHasBeenChecked = false
      this.emailIsValid = false
      this.emailIsTaken = false
      this.isDisposableAddress = false
      this.mailboxVerification = false
      this.didYouMean = null
    }
  },
}
</script>