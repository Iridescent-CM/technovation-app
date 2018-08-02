<template>
  <form>
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
  </form>
</template>

<script>
import Icon from '../../components/Icon'
import debounce from 'lodash/debounce'

import { mapActions, mapGetters } from 'vuex'

export default {
  name: 'email-input',

  components: {
    Icon,
  },

  data () {
    return {
      emailNeedsValidation: false,
      emailHasBeenChecked: false,
      emailIsValid: false,
      emailIsTaken: false,
      isDisposableAddress: false,
      mailboxVerification: false,
      didYouMean: null,
    }
  },

  props: {
    value: {
      type: Boolean,
      required: false,
    },
  },

  created () {
    this.debouncedEmailWatcher = debounce(this.validateEmailInput, 750)
    if (this.email.length) {
      this.emailHasBeenChecked = false
      this.emailNeedsValidation = true
      this.debouncedEmailWatcher()
    }
  },

  computed: {
    ...mapGetters(['getEmail']),

    email: {
      get () {
        return this.getEmail
      },

      set (value) {
        this.saveEmail({ email: value })
      },
    },

    problemsWithInput () {
      return this.emailHasBeenChecked && (
              !this.emailIsValid ||
                this.emailIsTaken ||
                  this.isDisposableAddress ||
                    !this.mailboxVerification
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

    nextStepEnabled (bool) {
      this.$emit('input', bool)
    },
  },

  methods: {
    ...mapActions(['saveEmail']),

    handleSubmit () {
      if (!this.nextStepEnabled) return false
      this.$router.push('password')
    },

    validateEmailInput () {
      let url = "/public/email_validations/new?address="
      url += encodeURIComponent(this.email)

      axios.get(url).then(({ data }) => {
        const attributes = Object.assign({}, data.data).attributes
        const resp = Object.assign({}, attributes)

        this.emailHasBeenChecked = true
        this.emailNeedsValidation = false

        this.emailIsValid = resp.isValid
        this.isDisposableAddress = resp.isDisposableAddress
        this.didYouMean = resp.didYouMean
        this.mailboxVerification = resp.mailboxVerification
        this.emailIsTaken = resp.isTaken
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

<style lang="scss" scoped>
</style>