<template>
  <div id="step-four">
    <ContainerHeader header-text="Set your email and password" />

    <div id="email-password" class="form-wrapper">
      <h1 class="text-tg-green text-2xl text-left mb-6" v-if="formValues.profileType === 'parent'">This is an account for beginners division</h1>
      <h1 class="text-tg-green text-2xl text-left mb-6" v-if="formValues.profileType === 'mentor'">This is an account for a mentor</h1>

      <FormulateInput
          name="email"
          type="email"
          :label="formValues.profileType === 'parent' ? 'Parent Email Address' : 'Email Address'"
          placeholder="Email address"
          validation="required|email"
          validation-name="Email address"
          error-behavior="live"
          @keyup="checkValidation"
          @blur="checkValidation"
          class="flex-grow "
          id="accountEmail"
          v-model="setAccountEmailForParentProfile"
          :disabled="formValues.profileType === 'parent'"
      />

      <p class="text-left text-sm mb-12">Please choose a personal, permanent email. A school or company email might block us from sending important messages to you.</p>

      <div class="double-wide">
        <FormulateInput
            name="password"
            type="password"
            label="Password"
            placeholder="At least 8 characters"
            validation="required|min:8,length"
            error-behavior="live"
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
      const validationErrors = document.querySelector('#step-four div[data-has-errors="true"]')

      if (validationErrors) {
        this.hasValidationErrors = true
      } else {
        this.hasValidationErrors = false
      }
    }
  },
  props: ['formValues', 'isLoading'],
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
    }
  }
}
</script>
