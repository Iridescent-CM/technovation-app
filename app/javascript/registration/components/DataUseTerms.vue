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

      <h4>No Advertising</h4>

      <p>
        We will never use, share, rent, or sell your personal data to
        anyone to advertise to or manipulate you.
      </p>

      <h4>Use of your personal data</h4>

      <p>
        We will only use your data to help guide you through the
        Technovation program, and to make the program better for everyone.
      </p>

      <p>
        We may share your personal data and activity with a trusted volunteer
        manager in your region who has been trained through a proper verification
        process in order for them to support you and your team during the program.
      </p>

      <h4>Program Update email from us</h4>

      <p>
        You can stop getting newsletter emails about the curriculum and program at any time by unsubscribing. You will continue to receive informational email about your account and team activity on the site.
      </p>

      <h4>Deleting your account and data</h4>
      <p>You can delete your account and our copy of your data at any time.</p>
    </div>

    <div class="panel__bottom-bar">
      <label>
        <input type="checkbox" />
        I agree to Technovation's data use terms
      </label>
    </div>
  </form>
</template>

<script>
export default {

}
</script>