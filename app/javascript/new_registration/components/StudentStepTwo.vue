<template>
  <div id="step-two">
    <ContainerHeader header-text="Basic Profile" />

    <div class="form-wrapper">
      <div id="step-two-student">
        <h2 class="registration-title">Student Information</h2>

        <div class="formulate-input-wrapper name-group">
          <FormulateInput
            name="firstName"
            type="text"
            label="First Name"
            placeholder="First Name"
            validation="required"
            validation-name="First name"
            error-behavior="live"
            @keyup="checkValidation"
            @blur="checkValidation"
            class="flex-grow pr-2"
          />

          <FormulateInput
            name="lastName"
            type="text"
            label="Last Name"
            placeholder="Last Name"
            validation="required"
            validation-name="Last name"
            error-behavior="live"
            @keyup="checkValidation"
            @blur="checkValidation"
            class="flex-grow pl-2"
          />
        </div>

        <FormulateInput
          type="date"
          name="dateOfBirth"
          label="Birthday"
          placeholder="Birthday"
          validation="required"
          validation-name="Birthday"
          error-behavior="live"
          @keyup="checkValidation"
          @blur="checkValidation"
        />

        <FormulateInput
          name="studentSchoolName"
          type="text"
          label="School Name"
          placeholder="School Name"
          validation="required"
          validation-name="School name"
          error-behavior="live"
          @keyup="checkValidation"
          @blur="checkValidation"
        />

        <div id="parent-information">
          <h2 class="registration-title">Parent Information</h2>

          <div class="formulate-input-wrapper name-group">
            <FormulateInput
              name="studentParentGuardianName"
              type="text"
              label="Name"
              placeholder="Parent Name"
              validation="required"
              validation-name="Parent name"
              error-behavior="live"
              @keyup="checkValidation"
              @blur="checkValidation"
              class="flex-grow pr-2"
            />
          </div>

          <FormulateInput v-if="formValues.profileType === 'parent'"
            name="studentParentGuardianEmail"
            type="email"
            label="Parent Email Address"
            placeholder="Parent Email address"
            validation="required|email"
            validation-name="Email address"
            error-behavior="live"
            @keyup="checkValidation"
            @blur="checkValidation"
          />

          <FormulateInput v-else
            name="studentParentGuardianEmail"
            type="email"
            label="Parent Email Address (Optional)"
            placeholder="Parent Email address"
            validation="email"
            validation-name="Email address"
          />
        </div>
      </div>
    </div>

    <ReferredBy />

    <div class="registration-btn-wrapper">
      <PreviousButton @prev="$emit('prev')"/>
      <NextButton @next="$emit('next')" :disabled="hasValidationErrors"/>
    </div>
  </div>
</template>

<script>
import ContainerHeader from "./ContainerHeader";
import ReferredBy from "./ReferredBy";
import PreviousButton from "./PreviousButton";
import NextButton from "./NextButton";

export default {
  name: "StudentStepTwo",
  components: {
    ContainerHeader,
    ReferredBy,
    PreviousButton,
    NextButton
  },
  data () {
    return {
      hasValidationErrors: true
    }
  },
  methods: {
    checkValidation() {
      const validationErrors = document.querySelector('#step-two-student div[data-has-errors="true"]')

      if (validationErrors) {
        this.hasValidationErrors = true
      } else {
        this.hasValidationErrors = false
      }
    }
  },
  props: ['formValues']
}
</script>
