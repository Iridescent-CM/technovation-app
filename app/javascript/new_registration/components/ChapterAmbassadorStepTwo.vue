<template>
  <div id="step-two">
    <ContainerHeader header-text="Basic Profile" />

    <div class="form-wrapper">
      <div id="step-two-chapter-ambassador">
        <h2 class="registration-title">Chapter Ambassador Information</h2>

        <div class="formulate-input-wrapper name-group">
          <FormulateInput name="firstName" id="firstName" type="text" label="First Name" placeholder="First Name"
            :validation="[['required'], ['matches', /^[^.-].*/]]" :validation-messages="{
              matches: 'Must start with an alphabetical character.'
            }" validation-name="First name" @keyup="checkValidation" @blur="checkValidation" class="grow pr-2" />

          <FormulateInput name="lastName" id="lastName" type="text" label="Last Name" placeholder="Last Name"
            :validation="[['required'], ['matches', /^[^.-].*/]]" :validation-messages="{
              matches: 'Must start with an alphabetical character.'
            }" validation-name="Last name" @keyup="checkValidation" @blur="checkValidation" class="grow pl-2" />
        </div>

        <FormulateInput name="meetsMinimumAgeRequirement" id="meetsMinimumAgeRequirement" type="checkbox"
          label="I confirm that I am 18 years or older" validation="required"
          :validation-messages="{ required: 'You must be 18 years or older in order to become a Chapter Ambassador' }"
          @keyup="checkValidation" @blur="checkValidation" @input="checkValidation" />

        <FormulateInput name="gender" :options="genderOptions" type="select" placeholder="Select an option"
          validation="required" validation-name="Gender identity" @keyup="checkValidation" @blur="checkValidation"
          label="Gender Identity" id="genderIdentity" input-class="ChapterAmbassadorSelectClass" />

        <FormulateInput name="chapterAmbassadorJobTitle" id="chapterAmbassadorJobTitle" type="text" label="Job Title"
          placeholder="Job Title" validation="required" validation-name="Job title" @keyup="checkValidation"
          @blur="checkValidation" />

        <FormulateInput name="chapterOrganizationName" id="chapterOrganizationName" type="text" label="Organization"
          readOnly="true" disabled="true" />

        <FormulateInput name="chapterAmbassadorOrganizationStatus" :options="organizationStatusOptions" type="select"
          @keyup="checkValidation" @blur="checkValidation" label="Status with Organization" id="organizationStatus"
          input-class="ChapterAmbassadorSelectClass" />

        <FormulateInput name="phoneNumber" id="phoneNumber" type="tel"
          :validation="[['matches', /^([\+\(\s.\-\/\d]{5,30}|)$/]]"
          :validation-messages="{ matches: 'Phone number is invalid.' }" label="Phone Number (optional)"
          @keyup="checkValidation" @blur="checkValidation" />
      </div>
    </div>

    <ReferredBy />

    <div class="registration-btn-wrapper">
      <PreviousButton @prev="$emit('prev')" />
      <NextButton @next="$emit('next')" :disabled="hasValidationErrors" />
    </div>
  </div>
</template>

<script>
import axios from "axios"

import { airbrake } from "utilities/utilities"
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
  data() {
    return {
      inviteCode: new URLSearchParams(document.location.search).get('invite_code'),
      genderOptions: [
        'Female',
        'Male',
        'Non-binary',
        'Prefer not to say'
      ],
      organizationStatusOptions: {
        employee: 'Employee',
        volunteer: 'Volunteer'
      },
      hasValidationErrors: true
    }
  },
  methods: {
    async getOrganizationName() {
      try {
        const response = await axios.get('/api/registration/chapter_organization_name', {
          params: { invite_code: this.inviteCode }
        })

        document.getElementById("chapterOrganizationName").value = response.data.chapterOrganizationName
      }
      catch (error) {
        airbrake.notify({
          error: `[REGISTRATION] Error getting chapter organization name - ${error.response.data}`
        })
      }
    },
    checkValidation() {
      const validationErrorMessages = Array.from(
        document.getElementsByClassName('validation-error-message')
      ).map(element => element.innerText)

      if (document.getElementById('firstName').value.length === 0 ||
        document.getElementById('lastName').value.length === 0 ||
        !document.getElementById('meetsMinimumAgeRequirement').checked ||
        document.getElementById('chapterAmbassadorJobTitle').value.length === 0 ||
        (document.getElementById('phoneNumber').value.length > 0 &&
          validationErrorMessages.some((message) => {
            return message.indexOf('Phone number is invalid') >= 0
          })
        ) ||
        validationErrorMessages.some((message) => {
          return (
            message.indexOf('years old to participate') >= 0 ||
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
  },
  async created() {
    await this.getOrganizationName()
  }
}
</script>
