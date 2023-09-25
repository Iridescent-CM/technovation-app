<template>
  <div id="step-two">
    <ContainerHeader header-text="Basic Profile" />

    <div class="form-wrapper">
      <div id="step-two-mentor">
        <h2 class="registration-title">Mentor Information</h2>

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
          input-class="mentorSelectClass"
        />

        <FormulateInput
          name="dateOfBirth"
          id="dateOfBirth"
          type="date"
          label="Birthday"
          placeholder="Birthday"
          validation="required|mentor_age|after:01/01/1900|before:01/01/2020"
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
          name="mentorSchoolCompanyName"
          id="mentorSchoolCompanyName"
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
          id="mentorJobTitle"
          type="text"
          label="Job Title"
          placeholder="Job Title"
          validation="required"
          validation-name="Job title"
          @keyup="checkValidation"
          @blur="checkValidation"
        />

        <div class="mentor-information" v-show="mentorTypeOptions.length > 0">
          <h4 class="registration-title">
            As a mentor you may call me a...<span class="formulate-required-field">*</span>
          </h4>

          <FormulateInput
            name="mentorTypes"
            id="mentorTypes"
            type="checkbox"
            :options="mentorTypeOptions"
            validation="required"
            :validation-messages="{ required: 'This field is required.' }"
            @keyup="checkValidation"
            @blur="checkValidation"
            @input="checkValidation"
          />
        </div>

        <div class="mentor-information" v-show="mentorProfileExpertiseOptions.length > 0">
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

          <p class="text-left pb-2">
            Add a description of yourself to your profile to help students get to know you.
            Entering at least 100 characters is required.
            You can change this later.<span class="formulate-required-field">*</span>
          </p>
          <FormulateInput
            name="mentorBio"
            id="mentorBio"
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
import axios from 'axios';

import { airbrake } from 'utilities/utilities'
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
      mentorTypeOptions: [],
      mentorProfileExpertiseOptions: [],
      hasValidationErrors: true
    }
  },
  methods: {
    checkValidation() {
      const validationErrorMessages = Array.from(
        document.getElementsByClassName('validation-error-message')
      ).map(element => element.innerText)

      const hasMentorTypeChecked = !!(document.querySelector('[name="mentorTypes"]:checked'));

      if (document.getElementById('firstName').value.length === 0 ||
        document.getElementById('lastName').value.length === 0 ||
        document.getElementById('dateOfBirth').value.length === 0 ||
        document.getElementById('mentorSchoolCompanyName').value.length === 0 ||
        document.getElementById('mentorJobTitle').value.length === 0 ||
        document.getElementById('mentorBio').value.length < 100 ||
        hasMentorTypeChecked === false ||
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
    },
    async getMentorExpertiseOptions () {
      try {
        const response = await axios.get('/registration/expertises')

        response.data.attributes.forEach((expertise) => {
          this.mentorProfileExpertiseOptions.push({
            label: expertise.name,
            value: expertise.id
          })
        })
      }
      catch(error) {
        airbrake.notify({
          error: `[REGISTRATION] Error getting mentor expertises - ${error.response.data}`
        })
      }
    },
    async getMentorTypeOptions () {
      try {
        const response = await axios.get('/registration/mentor_types')

        response.data.forEach((mentor_type) => {
          this.mentorTypeOptions.push({
            label: mentor_type.name,
            value: mentor_type.id
          })
        })
      }
      catch(error) {
        airbrake.notify({
          error: `[REGISTRATION] Error getting mentor types - ${error.response.data}`
        })
      }
    },
  },
  created() {
    this.getMentorExpertiseOptions();
    this.getMentorTypeOptions();
  },
  props: {
    formValues: {
      type: Object,
      required: true
    }
  }
}
</script>
