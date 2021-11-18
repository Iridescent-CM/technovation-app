<template>
  <div id="step-two">
    <ContainerHeader header-text="Basic Profile" />

    <div class="form-wrapper">
      <div id="step-two-mentor">
        <h2 class="registration-title">Mentor Information</h2>

        <div class="formulate-input-wrapper name-group">
          <FormulateInput
            name="firstName"
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
          label="Gender Identity"
          id="genderIdentity"
          input-class="mentorSelectClass"
        />

        <FormulateInput
          name="dateOfBirth"
          type="date"
          label="Birthday"
          placeholder="Birthday"
          validation="required|after:01/01/1900|before:01/01/2020"
          :validation-messages="{
            after: 'Please enter a valid birthday.',
            before: 'Please enter a valid birthday.'
          }"
          validation-name="Birthday"
          @keyup="checkValidation"
          @blur="checkValidation"
        />

        <FormulateInput
          name="mentorSchoolCompanyName"
          type="text"
          label="Company Name"
          placeholder="Company Name"
          validation="required"
          validation-name="Company name"
          @keyup="checkValidation"
          @blur="checkValidation"
        />

        <FormulateInput
          name="mentorJobTitle"
          type="text"
          label="Job Title"
          placeholder="Job Title"
          validation="required"
          validation-name="Job title"
          @keyup="checkValidation"
          @blur="checkValidation"
        />

        <FormulateInput
          name="mentorType"
          :options="mentorTypeOptions"
          type="select"
          placeholder="Select an option"
          label="As a mentor you may call me a ..."
          id="mentorType"
          input-class="mentorSelectClass"
        />

        <div id="mentor-information">
          <h2 class="registration-title">Skills & Interests</h2>

          <FormulateInput
            name="mentorExpertises"
            :options="mentorProfileExpertiseOptions"
            type="checkbox"
            id="mentorExpertise"
          />
        </div>

        <div class="mentor-information">
          <h2 class="registration-title">Set your personal summary</h2>

          <p class="text-left">Add a description of yourself to your profile to help students get to know you. You can change this later.</p>
          <FormulateInput
            name="mentorBio"
            type="textarea"
            validation="required|min:100,length"
            validation-name="Personal summary"
            @keyup="checkValidation"
            @blur="checkValidation"
            id="mentorSummary"
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
  name: "MentorStepTwo",
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
      mentorTypeOptions: [
        'Industry professional',
        'Educator',
        'Parent',
        'Past Technovation student'
      ],
      mentorProfileExpertiseOptions: [
        {value: 2, label: 'Coding'},
        {value: 8, label: 'Experience with Java'},
        {value: 9, label: 'Experience with Swift'},
        {value: 10, label: 'Business / entrepreneurship'},
        {value: 4, label: 'Project Management'},
        {value: 6, label: 'Marketing'},
        {value: 7, label: 'Design'}
      ],
      hasValidationErrors: true
    }
  },
  methods: {
    checkValidation() {
      const validationErrors = document.querySelector('#step-two-mentor div[data-has-errors="true"]')

      if (validationErrors) {
        this.hasValidationErrors = true
      } else {
        this.hasValidationErrors = false
      }
    }
  },
  props: ['formValues'],
}
</script>
