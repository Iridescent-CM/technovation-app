<template>
  <div id="step-four">
    <ContainerHeader header-text="Set your email and password" />

    <div id="email-password" class="form-wrapper">
      <h1
        v-if="formValues.profileType === 'mentor'"
        class="text-tg-green text-2xl text-left mb-6"
      >
        This is an account for a mentor
      </h1>
      <h1
        v-else-if="formValues.profileType === 'judge'"
        class="text-tg-green text-2xl text-left mb-6"
      >
        This is an account for a judge
      </h1>

      <FormulateInput
        id="email"
        v-model="setAccountEmailForParentOrAmbassadorProfile"
        name="email"
        type="email"
        :label="
          formValues.profileType === 'parent'
            ? 'Parent Email Address'
            : 'Email Address'
        "
        placeholder="Email address"
        :validation="emailValidation"
        validation-name="Email address"
        class="flex-grow"
        :disabled="
          formValues.profileType === 'parent' ||
          formValues.profileType === 'chapter_ambassador' ||
          formValues.profileType === 'club_ambassador'
        "
        @keyup="checkValidation"
        @blur="checkValidation"
      />

      <p
        v-if="formValues.profileType === 'judge'"
        class="text-left text-sm mb-12"
      >
        Please use your company email if you want your employer to know you
        volunteered with Technovation.
      </p>
      <p v-else class="text-left text-sm mb-12">
        Please choose a personal, permanent email. A school or company email
        might block us from sending important messages to you.
      </p>

      <div class="double-wide">
        <FormulateInput
          id="password"
          name="password"
          type="password"
          label="Password"
          placeholder="8+ chars with upper, lower, and a number"
          validation="required|min:8,length"
          @keydown="checkValidation"
          @keyup="checkValidation"
          @blur="checkValidation"
        />
      </div>
    </div>

    <div class="registration-btn-wrapper">
      <div>
        <PreviousButton @prev="$emit('prev')" />
      </div>

      <FormulateInput
        type="submit"
        :disabled="hasValidationErrors || isLoading"
        :label="isLoading ? 'Submitting...' : 'Submit this form'"
        input-class="registration-btns"
      />
    </div>
  </div>
</template>

<script>
import ContainerHeader from "./ContainerHeader";
import PreviousButton from "./PreviousButton";
import { passwordMeetsComplexity } from "../../helpers/passwordComplexity";

export default {
  name: "StepFour",
  components: {
    ContainerHeader,
    PreviousButton,
  },
  props: {
    formValues: {
      type: Object,
      required: true,
    },
    isLoading: {
      type: Boolean,
      required: true,
    },
  },
  data() {
    return {
      hasValidationErrors: true,
    };
  },
  computed: {
    setAccountEmailForParentOrAmbassadorProfile: {
      get() {
        if (this.formValues.profileType === "parent") {
          return this.formValues.studentParentGuardianEmail;
        } else if (
          this.formValues.profileType === "chapter_ambassador" ||
          this.formValues.profileType === "club_ambassador"
        ) {
          return this.formValues.email;
        } else {
          return this.formValues.email;
        }
      },
      set(accountEmailVal) {
        // eslint-disable-next-line vue/no-mutating-props
        this.formValues.email = accountEmailVal;
      },
    },
    emailValidation() {
      return "required|email";
    },
  },
  methods: {
    checkValidation() {
      const validationErrorMessages = Array.from(
        document.getElementsByClassName("validation-error-message")
      ).map((element) => element.innerText);

      if (
        document.getElementById("email").value.length === 0 ||
        !passwordMeetsComplexity(
          document.getElementById("password").value,
          document.getElementById("email").value
        ) ||
        validationErrorMessages.some((message) => {
          return (
            message.indexOf("is not a valid email address") >= 0 ||
            message.indexOf("Password must be at least") >= 0
          );
        })
      ) {
        this.hasValidationErrors = true;
      } else {
        this.hasValidationErrors = false;
      }
    },
  },
};
</script>
