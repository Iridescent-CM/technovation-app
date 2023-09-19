<template>
  <div id="step-two">
    <ContainerHeader header-text="Basic Profile" />

    <div class="form-wrapper">
      <div id="step-two-chapter-ambassador">
        <h2 class="registration-title">Chapter Ambassador Information</h2>

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
          name="gender"
          :options="genderOptions"
          type="select"
          placeholder="Select an option"
          validation="required"
          validation-name="Gender identity"
          @keyup="checkValidation"
          @blur="checkValidation"
          label="Gender Identity"
          id="genderIdentity"
          input-class="ChapterAmbassadorSelectClass"
        />

        <FormulateInput
          name="dateOfBirth"
          id="dateOfBirth"
          type="date"
          label="Birthday"
          placeholder="Birthday"
          validation="required|chapter_ambassador_age|after:01/01/1900|before:01/01/2020"
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
          name="chapterAmbassadorOrganizationCompanyName"
          id="chapterAmbassadorOrganizationCompanyName"
          type="text"
          label="Company Name"
          placeholder="Company Name"
          validation="required"
          validation-name="Company name"
          @keyup="checkValidation"
          @blur="checkValidation"
        />

        <FormulateInput
          name="chapterAmbassadorJobTitle"
          id="chapterAmbassadorJobTitle"
          type="text"
          label="Job Title"
          placeholder="Job Title"
          validation="required"
          validation-name="Job title"
          @keyup="checkValidation"
          @blur="checkValidation"
        />

        <div class="chapter-ambassador-information">
          <h2 class="registration-title">Set your personal summary</h2>

          <p class="text-left pb-2">
            Add a description of yourself to your profile to help students get to know you.
            Entering at least 100 characters is required.
            You can change this later.<span class="formulate-required-field">*</span>
          </p>
          <FormulateInput
            name="chapterAmbassadorBio"
            id="chapterAmbassadorBio"
            type="textarea"
            validation="required|min:100,length"
            validation-name="Personal summary"
            @keyup="checkValidation"
            @blur="checkValidation"
          />
        </div>
      </div>
    </div>

    <ReferredBy />

    <div class="registration-btn-wrapper">
      <PreviousButton @prev="$emit('prev')"/>
      <NextButton @next="$emit('next')" :disabled="hasValidationErrors" />
    </div>
  </div>
</template>

<script>
import ContainerHeader from "./ContainerHeader";
import ReferredBy from "./ReferredBy";
import PreviousButton from "./PreviousButton";
import NextButton from "./NextButton";

export default {
  name: "ChapterAmbassadorStepTwo",
  components: {
    ContainerHeader,
    ReferredBy,
    PreviousButton,
    NextButton
  },
  data () {
    return {
      genderOptions: [
        'Female',
        'Male',
        'Non-binary',
        'Prefer not to say'
      ],
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
        document.getElementById('chapterAmbassadorOrganizationCompanyName').value.length === 0 ||
        document.getElementById('chapterAmbassadorJobTitle').value.length === 0 ||
        document.getElementById('chapterAmbassadorBio').value.length < 100 ||
        validationErrorMessages.some((message) => {
          return (
            message.indexOf('years old to participate') >= 0 ||
            message.indexOf('Please enter a valid birthday') >= 0 ||
            message.indexOf('Personal summary must be at least') >= 0
          )
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
    }
  }
}
</script>
