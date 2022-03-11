<template>
  <div id="step-two">
    <ContainerHeader header-text="Basic Profile" />

    <div class="form-wrapper">
      <div id="step-two-judge">
        <h2 class="registration-title">Judge Information</h2>

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
            validation="required|judge_age|after:01/01/1900|before:01/01/2020"
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
          name="judgeSchoolCompanyName"
          id="judgeSchoolCompanyName"
          type="text"
          label="Company Name"
          placeholder="Company Name"
          validation="required"
          validation-name="Company name"
          @keyup="checkValidation"
          @blur="checkValidation"
        />

        <FormulateInput
          name="judgeJobTitle"
          id="judgeJobTitle"
          type="text"
          label="Job Title"
          placeholder="Job Title"
          validation="required"
          validation-name="Job title"
          @keyup="checkValidation"
          @blur="checkValidation"
        />
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
  name: "JudgeStepTwo",
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
        document.getElementById('judgeSchoolCompanyName').value.length === 0 ||
        document.getElementById('judgeJobTitle').value.length === 0 ||
        validationErrorMessages.some((message) => {
          return (
            message.indexOf('years old to participate') >= 0 ||
            message.indexOf('Please enter a valid birthday') >= 0
          )
        })) {

        this.hasValidationErrors = true
      } else {
        this.hasValidationErrors = false
      }
    },
  },
  props: {
    formValues: {
      type: Object,
      required: true
    }
  }
}
</script>
