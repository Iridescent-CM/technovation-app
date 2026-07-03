<template>
  <div id="step-two">
    <ContainerHeader header-text="Basic Profile" />

    <div class="form-wrapper">
      <div id="step-two-mentor">
        <h2 class="registration-title">Mentor Information</h2>

        <div class="formulate-input-wrapper name-group">
          <FormulateInput
            id="firstName"
            name="firstName"
            type="text"
            label="First Name"
            placeholder="First Name"
            :validation="[['required'], ['matches', /^[^.-].*/]]"
            :validation-messages="{
              matches: 'Must start with an alphabetical character.',
            }"
            validation-name="First name"
            class="flex-grow pr-2"
            @keyup="checkValidation"
            @blur="checkValidation"
          />

          <FormulateInput
            id="lastName"
            name="lastName"
            type="text"
            label="Last Name"
            placeholder="Last Name"
            :validation="[['required'], ['matches', /^[^.-].*/]]"
            :validation-messages="{
              matches: 'Must start with an alphabetical character.',
            }"
            validation-name="Last name"
            class="flex-grow pl-2"
            @keyup="checkValidation"
            @blur="checkValidation"
          />
        </div>

        <FormulateInput
          id="genderIdentity"
          name="gender"
          :options="genderOptions"
          type="select"
          placeholder="Select an option"
          validation="required"
          validation-name="Gender identity"
          label="Gender Identity"
          input-class="mentorSelectClass"
          @keyup="checkValidation"
          @blur="checkValidation"
        />

        <FormulateInput
          id="meetsMinimumAgeRequirement"
          name="meetsMinimumAgeRequirement"
          type="checkbox"
          label="I confirm that I am 18 years or older"
          validation="required"
          :validation-messages="{
            required: 'You must be 18 years or older in order to be a mentor',
          }"
          @keyup="checkValidation"
          @blur="checkValidation"
          @input="checkValidation"
        />

        <FormulateInput
          id="dateOfBirth"
          name="dateOfBirth"
          type="date"
          label="Birthday"
          placeholder="Birthday"
          :validation="birthdayValidation"
          :validation-messages="{
            after: 'Please enter a valid birthday.',
            before: 'Please enter a valid birthday.',
          }"
          validation-name="Birthday"
          @keyup="checkValidation"
          @blur="checkValidation"
          @change="checkValidation"
        />

        <p class="italic text-sm -mt-6 mb-8" style="margin-top: -12px">
          We use date of birth as a way to gain insight into who volunteers to
          mentor.<br />
          This info is optional.
        </p>

        <FormulateInput
          id="phoneNumber"
          name="phoneNumber"
          type="tel"
          :validation="[['matches', /^([\+\(\s.\-\/\d]{5,30}|)$/]]"
          :validation-messages="{ matches: 'Phone number is invalid.' }"
          label="Phone Number (optional)"
          @keyup="checkValidation"
          @blur="checkValidation"
        />

        <p class="italic text-sm -mt-6 mb-8" style="margin-top: -12px">
          Your phone number will be shared with the Technovation Ambassador for
          your region and may be used to contact you regarding volunteer
          opportunities. Providing your phone number is optional.
        </p>

        <FormulateInput
          id="mentorSchoolCompanyName"
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
          id="mentorJobTitle"
          name="mentorJobTitle"
          type="text"
          label="Job Title"
          placeholder="Job Title"
          validation="required"
          validation-name="Job title"
          @keyup="checkValidation"
          @blur="checkValidation"
        />

        <div v-show="mentorTypeOptions.length > 0" class="mentor-information">
          <h4 class="registration-title">
            As a mentor you may call me a...<span
              class="formulate-required-field"
              >*</span
            >
          </h4>

          <FormulateInput
            id="mentorTypes"
            name="mentorTypes"
            type="checkbox"
            :options="mentorTypeOptions"
            validation="required"
            :validation-messages="{ required: 'This field is required.' }"
            @keyup="checkValidation"
            @blur="checkValidation"
            @input="checkValidation"
          />
        </div>

        <div
          v-show="mentorProfileExpertiseOptions.length > 0"
          class="mentor-information"
        >
          <h2 class="registration-title">Skills & Interests</h2>

          <FormulateInput
            id="mentorExpertise"
            name="mentorExpertises"
            :options="mentorProfileExpertiseOptions"
            type="checkbox"
          />
        </div>

        <div class="mentor-information">
          <h2 class="registration-title">Set your personal summary</h2>

          <p class="text-left pb-2">
            Add a description of yourself to your profile to help students get
            to know you. Entering at least 100 characters, but no more than 1500
            characters, is required. You can change this later.
            <span class="formulate-required-field">*</span>
          </p>
          <FormulateInput
            id="mentorBio"
            name="mentorBio"
            type="textarea"
            validation="required|between:100,1500,length"
            validation-name="Personal summary"
            @keyup="checkValidation"
            @blur="checkValidation"
          />
        </div>
      </div>
    </div>

    <ReferredBy />

    <div class="registration-btn-wrapper">
      <PreviousButton @prev="$emit('prev')" />
      <NextButton :disabled="hasValidationErrors" @next="$emit('next')" />
    </div>
  </div>
</template>

<script>
import axios from "axios";
import { DateTime } from "luxon";

import { airbrake } from "utilities/utilities";
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
    NextButton,
  },
  props: {
    formValues: {
      type: Object,
      required: true,
    },
  },
  data() {
    return {
      genderOptions: ["Female", "Male", "Non-binary", "Prefer not to say"],
      mentorTypeOptions: [],
      mentorProfileExpertiseOptions: [],
      hasValidationErrors: true,
    };
  },
  computed: {
    birthdayValidation() {
      const today = DateTime.now().toFormat("MM/dd/yyyy");

      return `mentor_age|after:01/01/1900|before:${today}`;
    },
  },
  created() {
    this.getMentorExpertiseOptions();
    this.getMentorTypeOptions();
  },
  methods: {
    checkValidation() {
      const validationErrorMessages = Array.from(
        document.getElementsByClassName("validation-error-message")
      ).map((element) => element.innerText);

      const hasMentorTypeChecked = !!document.querySelector(
        '[name="mentorTypes"]:checked'
      );

      if (
        document.getElementById("firstName").value.length === 0 ||
        document.getElementById("lastName").value.length === 0 ||
        !document.getElementById("meetsMinimumAgeRequirement").checked ||
        document.getElementById("mentorSchoolCompanyName").value.length === 0 ||
        document.getElementById("mentorJobTitle").value.length === 0 ||
        document.getElementById("mentorBio").value.length < 100 ||
        document.getElementById("mentorBio").value.length > 1500 ||
        (document.getElementById("phoneNumber").value.length > 0 &&
          validationErrorMessages.some((message) => {
            return message.indexOf("Phone number is invalid") >= 0;
          })) ||
        hasMentorTypeChecked === false ||
        validationErrorMessages.some((message) => {
          return (
            message.indexOf("years old to participate") >= 0 ||
            message.indexOf("Please enter a valid birthday") >= 0 ||
            message.indexOf("Personal summary must be at least") >= 0
          );
        })
      ) {
        this.hasValidationErrors = true;
      } else {
        this.hasValidationErrors = false;
      }
    },
    async getMentorExpertiseOptions() {
      try {
        const response = await axios.get("/api/registration/mentor_expertises");

        response.data.forEach((expertise) => {
          this.mentorProfileExpertiseOptions.push({
            label: expertise.name,
            value: expertise.id,
          });
        });
      } catch (error) {
        airbrake.notify({
          error: `[REGISTRATION] Error getting mentor expertises - ${error.response.data}`,
        });
      }
    },
    async getMentorTypeOptions() {
      try {
        const response = await axios.get("/api/registration/mentor_types");

        response.data.forEach((mentor_type) => {
          this.mentorTypeOptions.push({
            label: mentor_type.name,
            value: mentor_type.id,
          });
        });
      } catch (error) {
        airbrake.notify({
          error: `[REGISTRATION] Error getting mentor types - ${error.response.data}`,
        });
      }
    },
  },
};
</script>
