<template>
  <form
    @submit.prevent="handleSubmit"
    class="panel panel--contains-bottom-bar panel--contains-top-bar"
  >
    <div class="panel__top-bar">
      Agree to our data use terms
    </div>

    <div class="panel__content">
      <h3>How Technovation uses your data</h3>

      <p>
        Please take a moment to read this before signing up.
        We have tried to make it very easy to understand.
        You can
        <a
          href="http://iridescentlearning.org/terms-of-use/"
          target="_blank"
        >read our full terms of use here</a>;
        below is a summary.
      </p>

      <hr />

      <p>Technovation is owned by a non-profit organization called Iridescent.</p>

      <h4>No advertising</h4>

      <p>
        We will never use, share, rent, or sell your personal data to
        anyone to advertise to you, or to manipulate you.
      </p>

      <h4>Your personal data</h4>

      <p>
        We will only use your data to help guide you through the
        Technovation program, and to learn how we can make the program
        better and easier for everyone.
      </p>

      <p>
        We may share your personal data and activity with a trusted volunteer
        manager in your region—who has been trained through a proper verification
        process—in order for them to support you and your team during the program.
      </p>

      <h4>Newsletters and informational email</h4>

      <p>
        You can unsubcribe from our newsletters about the curriculum and
        program at any time. These emails are different from informational
        email about your account and team activity, which you will continue
        to receive.
      </p>

      <h4>Deleting your account and data</h4>

      <p>
        You can delete your account and data, and get a copy of your data, at any time.
        This would remove you from your team and our program.
      </p>
    </div>

    <div class="panel__bottom-bar">
      <label>
        <input type="checkbox" v-model="termsAgreed" />
        I agree to Technovation's data use terms
      </label>
    </div>
  </form>
</template>

<script>
import { mapActions, mapGetters } from 'vuex'

export default {
  name: 'data-use-terms',

  computed: {
    ...mapGetters(['getTermsAgreed']),

    termsAgreed: {
      get () {
        return this.getTermsAgreed
      },

      set (value) {
        this.updateTermsAgreed({ termsAgreed: value })
      }
    },
  },

  methods: mapActions(['updateTermsAgreed']),
}
</script>

<style scoped>
h3,
h4 {
  -webkit-font-smoothing: antialiased;
}

h4 {
  margin: 1rem 0 0;
  padding: 0;
}
</style>