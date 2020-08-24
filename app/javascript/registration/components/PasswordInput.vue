<template>
  <div id="password-form">
    <label for="password">Password</label>

    <Password
      id="password"
      autocomplete="new-password"
      placeholder="Use at least 8 characters"
      v-model="password"
      name="account[password]"
      :toggle="true"
      :secure-length="8"
      @score="showScore"
    />

    <div
      v-if="nextStepEnabled"
      :class="['flash', flashForStrength]"
    >
      {{ strengthNextStepMsg }}
    </div>
  </div>
</template>

<script>
import Password from 'vue-password-strength-meter'

export default {
  name: 'password-validation',

  components: {
    Password,
  },

  data () {
    return {
      score: 0,
      password: '',
    }
  },

  props: {
    value: {
      type: Boolean,
      required: false,
    },
  },

  computed: {
    nextStepEnabled () {
      return this.password.length >= 8
    },

    strengthNextStepMsg () {
      if (this.score > 2) {
        return "Your password looks good! You're ready for the next step!"
      } else if (this.score > 0) {
        return "Your password looks okay, but you can go to the next step."
      } else {
        return "Your password looks weak, and we recommend that you make it stronger, but you can go to the next step."
      }
    },

    flashForStrength () {
      if (this.score > 2) {
        return 'flash--success'
      } else if (this.score > 0) {
        return ''
      } else {
        return 'flash--alert'
      }
    },
  },

  watch: {
    nextStepEnabled (bool) {
      this.$emit('input', bool)
    },
  },

  methods: {
    showScore (score) {
      this.score = score
    },
  },
}
</script>

<style lang="scss">
#password-form {
  .Password {
    max-width: 100% !important;
    margin: 0.5rem 0;
  }

  .Password__badge {
    padding: 0.5rem 0 !important;
    height: auto !important;
    text-align: center !important;
  }

  .Password__field {
    border: 2px solid #ccc !important;

    &:hover {
      border-color: #a3a3a3 !important;
    }

    &:focus {
      border-color: #903D54 !important;
      box-shadow: inset 0 1px 3px rgba(0,0,0,0.06), 0 0 5px rgba(144, 61, 84, 0.7);
      outline: none !important;
    }
  }
}
</style>