<template>
  <form
    @submit.prevent="handleSubmit"
    class="panel panel--contains-bottom-bar panel--contains-top-bar"
  >
    <div class="panel__top-bar">
      Start with your email address
    </div>

    <div class="panel__content">
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
        v-model="mutableEmail"
        @input="emailSetByProps = false"
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
            :href="`/signin?email=${this.mutableEmail}`"
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
import Icon from '../../components/Icon'
import debounce from 'lodash/debounce'

export default {
  name: 'email-validation',

  components: {
    Icon,
  },

  data () {
    return {
      mutableEmail: '',
      emailSetByProps: false,
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
    email: {
      type: String,
      required: false,
      default: '',
    },
  },

  created () {
    this.debouncedEmailWatcher = debounce(this.validateEmailInput, 750)

    if (this.email.length) {
      this.emailHasBeenChecked = true
      this.emailIsValid = true
      this.emailIsTaken = false
      this.isDisposableAddress = false
      this.mailboxVerification = true

      this.emailSetByProps = true
      this.mutableEmail = this.email
    }
  },

  computed: {
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
    mutableEmail () {
      if (!this.emailSetByProps && this.mutableEmail.length) {
        this.emailHasBeenChecked = false
        this.emailNeedsValidation = true
        this.debouncedEmailWatcher()
      } else if (!this.emailSetByProps) {
        this.reset()
      }
    },
  },

  methods: {
    handleSubmit () {
      if (!this.nextStepEnabled) return false
      this.$router.push('password')
    },

    validateEmailInput () {
      let url = "/public/email_validations/new?address="
      url += encodeURIComponent(this.mutableEmail)

      axios.get(url).then(({ data }) => {
        const attributes = Object.assign({}, data.data).attributes
        const resp = Object.assign({}, attributes)

        this.emailHasBeenChecked = true
        this.emailNeedsValidation = false

        this.emailIsValid = resp.is_valid
        this.isDisposableAddress = resp.is_disposable_address
        this.didYouMean = resp.did_you_mean
        this.mailboxVerification = resp.mailbox_verification
        this.emailIsTaken = resp.is_taken
      }).catch(err => {
        console.error(err)
      })
    },

    handleDidYouMean () {
      this.emailNeedsValidation = false
      this.emailHasBeenChecked = false
      this.emailSetByProps = false
      this.mutableEmail = this.didYouMean
    },

    reset () {
      this.mutableEmail = ''
      this.emailSetByProps = false
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