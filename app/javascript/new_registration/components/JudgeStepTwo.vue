<template>
  <div id="step-two">
    <ContainerHeader header-text="Basic Profile" />

    <div class="form-wrapper">
      <div id="step-two-judge">
        <h2 class="registration-title">Judge Information</h2>

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
          :validation-messages="{ required: 'You must be 18 years or older in order to be a judge' }"
          @keyup="checkValidation" @blur="checkValidation" @input="checkValidation" />

        <FormulateInput name="dateOfBirth" id="dateOfBirth" type="date" label="Birthday" placeholder="Birthday"
          @keyup="checkValidation" @blur="checkValidation" @change="checkValidation" />

        <p class="italic text-sm -mt-6 mb-8" style="margin-top: -12px;">
          We use date of birth as a way to gain insight into who volunteers to judge.<br>
          This info is optional.
        </p>

        <FormulateInput name="phoneNumber" id="phoneNumber" type="tel"
          :validation="[['matches', /^([\+\(\s.\-\/\d]{5,30}|)$/]]"
          :validation-messages="{ matches: 'Phone number is invalid.' }" label="Phone Number (optional)"
          @keyup="checkValidation" @blur="checkValidation" />

        <p class="italic text-sm -mt-6 mb-8" style="margin-top: -12px;">
          Your phone number will be shared with the Technovation Ambassador for your region and may be used to contact
          you regarding volunteer opportunities. Providing your phone number is optional.
        </p>

        <FormulateInput name="gender" :options="genderOptions" type="select" placeholder="Select an option"
          validation="required" validation-name="Gender identity" @keyup="checkValidation" @blur="checkValidation"
          label="Gender Identity" id="genderIdentity" input-class="mentorSelectClass" />

        <FormulateInput name="judgeSchoolCompanyName" id="judgeSchoolCompanyName" type="text" label="Company Name"
          placeholder="Company Name" validation="required" validation-name="Company name" @keyup="checkValidation"
          @blur="checkValidation" />

        <FormulateInput name="judgeJobTitle" id="judgeJobTitle" type="text" label="Job Title" placeholder="Job Title"
          validation="required" validation-name="Job title" @keyup="checkValidation" @blur="checkValidation" />

        <div class="judge-information" v-show="judgeTypeOptions.length > 0">
          <h4 class="registration-title">
            As a judge you may call me a...<span class="formulate-required-field">*</span>
          </h4>

          <FormulateInput name="judgeTypes" id="judgeTypes" type="checkbox" :options="judgeTypeOptions"
            validation="required" :validation-messages="{ required: 'This field is required.' }"
            @keyup="checkValidation" @blur="checkValidation" @input="checkValidation" />
        </div>
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
import axios from 'axios';

import { airbrake } from 'utilities/utilities'
import ContainerHeader from "./ContainerHeader";
import ReferredBy from "./ReferredBy";
import PreviousButton from "./PreviousButton";
import NextButton from "./NextButton";

export default {
  name: "JudgeStepTwo",
  components: {
    ContainerHeader,
    ReferredBy,
    PreviousButton,
    NextButton
  },
  data() {
    return {
      genderOptions: [
        'Female',
        'Male',
        'Non-binary',
        'Prefer not to say'
      ],
      judgeTypeOptions: [],
      hasValidationErrors: true
    }
  },
  methods: {
    checkValidation() {
      const validationErrorMessages = Array.from(
        document.getElementsByClassName('validation-error-message')
      ).map(element => element.innerText)

      const hasjudgeTypeChecked = !!(document.querySelector('[name="judgeTypes"]:checked'));

      if (document.getElementById('firstName').value.length === 0 ||
        document.getElementById('lastName').value.length === 0 ||
        !document.getElementById('meetsMinimumAgeRequirement').checked ||
        document.getElementById('judgeSchoolCompanyName').value.length === 0 ||
        document.getElementById('judgeJobTitle').value.length === 0 ||
        (document.getElementById('phoneNumber').value.length > 0 &&
          validationErrorMessages.some((message) => {
            return message.indexOf('Phone number is invalid') >= 0
          })
        ) ||
        hasjudgeTypeChecked === false) {
        this.hasValidationErrors = true
      } else {
        this.hasValidationErrors = false
      }
    },
    async getJudgeTypeOptions() {
      try {
        const response = await axios.get('/api/registration/judge_types')

        response.data.forEach((judge_type) => {
          this.judgeTypeOptions.push({
            label: judge_type.name,
            value: judge_type.id
          })
        })
      }
      catch (error) {
        airbrake.notify({
          error: `[REGISTRATION] Error getting judge types - ${error.response.data}`
        })
      }
    },
  },
  created() {
    this.getJudgeTypeOptions();
  },
  props: {
    formValues: {
      type: Object,
      required: true
    }
  }
}
</script>
