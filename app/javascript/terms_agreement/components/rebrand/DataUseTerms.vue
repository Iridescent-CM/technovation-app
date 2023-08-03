<template>
  <div class="w-full lg:w-3/4 mx-auto">
    <EnergeticContainer heading="Agree to our data terms">
      <form
        ref="dataUseTermsForm"
        @submit.prevent="handleSubmit"
      >
        <div>
          <h3 class="font-semibold text-xl">How Technovation Girls uses your data</h3>

          <p class="mt-4">
            Please take a moment to read this before signing up.
            We have tried to make it very easy to understand.
            You can
            <a
              href="http://iridescentlearning.org/terms-of-use/"
              target="_blank"
              class="tw-link"
            >read our full terms of use here</a>;
            below is a summary.
          </p>

          <ThickRule/>

          <p>Technovation Girls is owned by a non-profit organization called Technovation.</p>

          <h4 class="font-semibold mt-4">No advertising</h4>

          <p>
            We will never use, share, rent, or sell your personal data to
            anyone to advertise to you, or to manipulate you.
          </p>

          <h4 class="font-semibold mt-4">Your personal data</h4>

          <p>
            We will only use your data to help guide you through the
            Technovation Girls program, and to learn how we can make the program
            better and easier for everyone.
          </p>

          <p>
            We may share your personal data and activity with a trusted volunteer
            manager in your region—who has been trained through a proper verification
            process—in order for them to support you and your team during the program.
          </p>

          <h4 class="font-semibold mt-4">Newsletters and informational email</h4>

          <p>
            You can unsubscribe from our <strong>newsletters</strong> about the
            curriculum and program at any time. This is different from
            <strong>informational email</strong> about your account and team
            activity, which you will continue to receive.
          </p>

          <h4 class="font-semibold mt-4">Deleting your account and data</h4>

          <p>
            You can delete your account and data, and get a copy of your data, at any time.
            Deleting your data will remove you from your team and our program.
          </p>


          <h4 class="font-semibold mt-4">Background Checks</h4>

          <p>
            Background checks are reports of your work and legal history.
            In the United States all mentors are required to complete and pass
            a background check in order to be allowed and verified on our site.
          </p>

          <p>
            In other countries and territories, we will randomly select mentors
            to provide references and legal certifications, and to submit to
            background checks where possible. If you are selected, we will
            contact you to complete this process. You must consent to this to
            be allowed and verified on our site.
          </p>

          <p>Thank you for helping us keep our students safe.</p>

          <div class="py-4 text-right">
            <label for="terms_agreement_checkbox" class="m-0">
              <input
                type="checkbox"
                id="terms_agreement_checkbox"
                v-model="termsAgreed"
                :disabled="isLocked"
              />
              I agree to these data use terms
            </label>
          </div>
        </div>

        <div class="text-right">
          <button
            ref="dataUseTermsSubmitButton"
            type="submit"
            id="terms_agreement_submit"
            class="tw-green-btn"
            :disabled="!termsAgreed"
          >{{ submitButtonText }}</button>
        </div>
      </form>
    </EnergeticContainer>
  </div>
</template>

<script>
import { createNamespacedHelpers } from 'vuex'
import EnergeticContainer from "../../../components/rebrand/EnergeticContainer";
import ThickRule from "../../../components/rebrand/ThickRule";

const { mapState, mapGetters, mapActions } = createNamespacedHelpers('registration')

export default {
  name: 'data-use-terms',
  components: {EnergeticContainer, ThickRule},

  props: {
    handleSubmit: {
      type: Function,
      default: function () {
        if (!this.termsAgreed) return false
        this.$router.push({ name: 'location' })
      },
    },

    submitButtonText: {
      type: String,
      default: 'Next',
    },
  },

  computed: {
    ...mapState(['isLocked']),

    termsAgreed: {
      get () {
        return this.$store.state.registration.termsAgreed
      },

      set (value) {
        if (!this.isLocked) {
          this.updateTermsAgreed({ termsAgreed: value });
        }
      },
    },
  },

  methods: {
    ...mapActions(['updateTermsAgreed']),
  },
}
</script>