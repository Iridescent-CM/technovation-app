<template>
  <div id="step-four">
    <ContainerHeader header-text="Set your email and password" />

    <div id="email-password" class="form-wrapper">
      <h1 class="text-tg-green text-2xl text-left mb-6" v-if="formValues.profileType === 'mentor'">This is an account for a mentor</h1>
      <h1 class="text-tg-green text-2xl text-left mb-6" v-else-if="formValues.profileType === 'judge'">This is an account for a judge</h1>

      <FormulateInput
        name="email"
        id="email"
        type="email"
        :label="formValues.profileType === 'parent' ? 'Parent Email Address' : 'Email Address'"
        placeholder="Email address"
        :validation="emailValidation"
        validation-name="Email address"
        @keyup="checkValidation"
        @blur="checkValidation"
        class="flex-grow"
        v-model="setAccountEmailForParentProfile"
        :disabled="formValues.profileType === 'parent'"
      />

      <p class="text-left text-sm mb-12" v-if="formValues.profileType === 'judge'">Please use your company email if you want your employer to know you volunteered with Technovation.</p>
      <p class="text-left text-sm mb-12" v-else >Please choose a personal, permanent email. A school or company email might block us from sending important messages to you.</p>

      <div class="double-wide">
        <FormulateInput
          name="password"
          id="password"
          type="password"
          label="Password"
          placeholder="At least 8 characters"
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

export default {
  name: "StepFour",
  components: {
    ContainerHeader,
    PreviousButton
  },
  data () {
    return {
      hasValidationErrors: true
    }
  },
  methods: {
    checkValidation() {
      const validationErrorMessages = Array.from(
        document.getElementsByClassName('validation-error-message')
      ).map(element => element.innerText)

      if (document.getElementById('email').value.length === 0 ||
        document.getElementById('password').value.length < 8 ||
        validationErrorMessages.some((message) => {
          return (message.indexOf('is not a valid email address') >= 0 ||
            message.indexOf('Password must be at least') >= 0)
        })) {

        this.hasValidationErrors = true
      } else {
        this.hasValidationErrors = false
      }
    }
  },
  props: {
    formValues: {
      type: Object,
      required: true
    },
    isLoading: {
      type: Boolean,
      required: true
    }
  },
  computed:{
    setAccountEmailForParentProfile: {
      get(){
        if (this.formValues.profileType === "parent") {
          return this.formValues.studentParentGuardianEmail
        } else {
          return  this.formValues.email
        }
      },
      set(accountEmailVal){
        this.formValues.email = accountEmailVal
      }
    },
    emailValidation() {
        return 'required|email'
    }
  }
}
</script>
