<template>
  <div id="step-two">
    <ContainerHeader header-text="Basic Profile" />

    <div class="form-wrapper">
      <div id="step-two-student">
        <h2 class="registration-title">Student Information</h2>

        <div class="formulate-input-wrapper name-group">
          <FormulateInput
            name="firstName"
            id="firstName"
            type="text"
            label="First Name"
            placeholder="First Name"
            validation="required"
            validation-name="First name"
            @keyup="checkValidation"
            @blur="checkValidation"
            class="flex-grow pr-2"
          />

          <FormulateInput
            name="lastName"
            id="lastName"
            type="text"
            label="Last Name"
            placeholder="Last Name"
            validation="required"
            validation-name="Last name"
            @keyup="checkValidation"
            @blur="checkValidation"
            class="flex-grow pl-2"
          />
        </div>

        <FormulateInput
          name="dateOfBirth"
          id="dateOfBirth"
          type="date"
          label="Birthday"
          placeholder="Birthday"
          :validation="birthdayValidation"
          :validation-messages="{
            after: 'Please enter a valid birthday.',
            before: 'Please enter a valid birthday.'
          }"
          validation-name="Birthday"
          @keyup="checkValidation"
          @blur="checkValidation"
          @change="checkValidation"
        />

        <FormulateInput
          name="studentSchoolName"
          id="studentSchoolName"
          type="text"
          label="School Name"
          placeholder="School Name"
          validation="required"
          validation-name="School name"
          @keyup="checkValidation"
          @blur="checkValidation"
        />

        <div id="parent-information">
          <h2 class="registration-title">Parent Information</h2>

          <div class="formulate-input-wrapper name-group">
            <FormulateInput
              name="studentParentGuardianName"
              id="studentParentGuardianName"
              type="text"
              label="Name"
              placeholder="Parent Name"
              validation="required"
              validation-name="Parent name"
              @keyup="checkValidation"
              @blur="checkValidation"
              class="flex-grow pr-2"
            />
          </div>

          <FormulateInput
            name="studentParentGuardianEmail"
            id="studentParentGuardianEmail"
            type="email"
            :label="formValues.profileType === 'parent' ? 'Parent Email Address' : 'Parent Email Address (Optional)'"
            placeholder="Parent Email address"
            :validation="formValues.profileType === 'parent' ? 'required|email' : 'optional|email'"
            validation-name="Email address"
            @keyup="checkValidation"
            @blur="checkValidation"
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
import { DateTime } from 'luxon';

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
      const validationErrorMessages = Array.from(
        document.getElementsByClassName('validation-error-message')
      ).map(element => element.innerText)

      if (document.getElementById('firstName').value.length === 0 ||
        document.getElementById('lastName').value.length === 0 ||
        document.getElementById('dateOfBirth').value.length === 0 ||
        document.getElementById('studentSchoolName').value.length === 0 ||
        document.getElementById('studentParentGuardianName').value.length === 0 ||
        (this.formValues.profileType === 'parent' &&
          document.getElementById('studentParentGuardianEmail').value.length === 0) ||
        validationErrorMessages.some((message) => {
          return (
            message.indexOf('is not a valid email address') >= 0 ||
            message.indexOf('years old to participate') >= 0 ||
            message.indexOf('Please enter a valid birthday') >= 0
          )
        })) {

        this.hasValidationErrors = true
      } else {
        this.hasValidationErrors = false
      }
    }
  },
  computed: {
    birthdayValidation() {
      const today = DateTime.now().toFormat('MM/dd/yyyy')

      if (this.formValues.profileType === 'parent') {
        return `required|student_age:beginner|after:01/01/1900|before:${today}`
      } else {
        return `required|student_age|after:01/01/1900|before:${today}`
      }
    }
  },
  props: ['formValues']
}
</script>
