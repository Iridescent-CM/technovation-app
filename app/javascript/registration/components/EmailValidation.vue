<template>
  <form>
    <label for="email">Email</label>
    <input type="email" name="email" v-model="email" />
  </form>
</template>

<script>
import debounce from 'lodash/debounce'

export default {
  name: 'email-validation',

  data () {
    return {
      email: '',
    }
  },

  watch: {
    email () {
      debounce(this.validateEmailInput, 500)
    },
  },

  methods: {
    validateEmailInput () {
      axios.get('https://api.mailgun.net/v3/address/validate', {
        auth: {
          username: 'api',
          password: 'abc123',
        },
        data: {
          address: encodeURIComponent('joe@joesak.com')
        },
      })
    },
  },
}
</script>