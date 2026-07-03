<template>
  <div>
    <label for="email">Email Address</label>

    <input
      id="email"
      v-model="email"
      type="email"
      autocomplete="email"
      name="account[email]"
      placeholder="example: janie.doe@gmail.com"
    />

    <p class="hint">
      Please choose a personal, permanent email. A school or company email might
      block us from sending important messages to you.
    </p>

    <div v-if="emailNeedsValidation" class="text-align--center">
      Checking this email...<br />
      <icon name="spinner" class="spin" />
    </div>

    <template v-if="problemsWithInput">
      <div class="flash flash--alert">
        Sorry, the email address you typed appears to be invalid.
      </div>

      <div v-if="emailIsTaken" class="flash flash--alert">
        That email is taken. Try
        <a
          class="cursor--pointer text-decoration--underline"
          :href="`/signin?email=${email}`"
        >
          signing in
        </a>
        instead.
      </div>

      <div v-if="isDisposableAddress" class="flash flash--alert">
        You cannot use a disposable email address.
      </div>

      <div v-if="didYouMean" class="flash font-weight--bold">
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

    <div v-if="nextStepEnabled" class="flash flash--success">
      Your email looks good!
    </div>
  </div>
</template>

<script>
import { createNamespacedHelpers } from "vuex";

import Icon from "../../components/Icon";
import debounce from "lodash/debounce";

const { mapActions } = createNamespacedHelpers("registration");

export default {
  name: "EmailInput",

  components: {
    Icon,
  },

  props: {
    value: {
      type: Boolean,
      required: false,
    },
  },

  data() {
    return {
      emailNeedsValidation: false,
      emailHasBeenChecked: false,
      emailIsValid: false,
      emailIsTaken: false,
      isDisposableAddress: false,
      mailboxVerification: null,
      didYouMean: null,
    };
  },

  computed: {
    email: {
      get() {
        return this.$store.state.registration.email;
      },

      set(value) {
        this.$store.commit("registration/email", value);
      },
    },

    problemsWithInput() {
      return (
        this.emailHasBeenChecked &&
        (!this.emailIsValid ||
          this.emailIsTaken ||
          this.isDisposableAddress ||
          (this.mailboxVerification != null && !this.mailboxVerification))
      );
    },

    nextStepEnabled() {
      return this.emailHasBeenChecked && !this.problemsWithInput;
    },
  },

  watch: {
    email() {
      if (this.email && this.email.length) {
        this.emailHasBeenChecked = false;
        this.emailNeedsValidation = true;
        this.debouncedEmailWatcher();
      } else {
        this.reset();
      }
    },

    nextStepEnabled(bool) {
      this.$emit("input", bool);
    },
  },

  created() {
    this.debouncedEmailWatcher = debounce(this.validateEmailInput, 750);
    if (this.email && this.email.length) {
      this.emailHasBeenChecked = false;
      this.emailNeedsValidation = true;
      this.debouncedEmailWatcher();
    }
  },

  methods: {
    ...mapActions(["saveEmail"]),

    handleSubmit() {
      if (!this.nextStepEnabled) return false;
      this.$router.push("password");
    },

    validateEmailInput() {
      const saveEmail = this.saveEmail({ email: this.email });

      saveEmail.then(() => {
        let url = "/public/email_validations/new?address=";
        url += encodeURIComponent(this.email);

        axios
          .get(url)
          .then(({ data }) => {
            const attributes = Object.assign({}, data.data).attributes;
            const resp = Object.assign({}, attributes);

            this.emailHasBeenChecked = true;
            this.emailNeedsValidation = false;

            this.emailIsValid = resp.isValid;
            this.isDisposableAddress = resp.isDisposableAddress;
            this.didYouMean = resp.didYouMean;
            this.mailboxVerification = resp.mailboxVerification;
            this.emailIsTaken = resp.isTaken;
          })
          .catch((err) => {
            console.error(err);
          });
      });
    },

    handleDidYouMean() {
      this.emailNeedsValidation = false;
      this.emailHasBeenChecked = false;
      this.email = this.didYouMean;
    },

    reset() {
      this.email = "";
      this.emailNeedsValidation = false;
      this.emailHasBeenChecked = false;
      this.emailIsValid = false;
      this.emailIsTaken = false;
      this.isDisposableAddress = false;
      this.mailboxVerification = null;
      this.didYouMean = null;
    },
  },
};
</script>

<style lang="scss" scoped></style>
