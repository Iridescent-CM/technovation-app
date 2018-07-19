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
        .then(resp => {
          this.isValidating = false
          console.log(resp)
        }).catch(err => {
          this.isValidating = false
          console.error(err)
        })
    },
  },
}
</script>