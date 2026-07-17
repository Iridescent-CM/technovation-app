<template>
  <div id="step-two">
    <ContainerHeader header-text="Basic Profile" />

    <div class="form-wrapper">
      <div id="step-two-club-ambassador">
        <h2 class="registration-title">Club Ambassador Information</h2>

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
          id="meetsMinimumAgeRequirement"
          name="meetsMinimumAgeRequirement"
          type="checkbox"
          label="I confirm that I am 18 years or older"
          validation="required"
          :validation-messages="{
            required:
              'You must be 18 years or older in order to become a Club Ambassador',
          }"
          @keyup="checkValidation"
          @blur="checkValidation"
          @input="checkValidation"
        />

        <FormulateInput
          id="genderIdentity"
          name="gender"
          :options="genderOptions"
          type="select"
          placeholder="Select an option"
          validation="required"
          validation-name="Gender identity"
          label="Gender Identity"
          input-class="ChapterAmbassadorSelectClass"
          @keyup="checkValidation"
          @blur="checkValidation"
        />

        <FormulateInput
          id="clubAmbassadorJobTitle"
          name="clubAmbassadorJobTitle"
          type="text"
          label="Job Title"
          placeholder="Job Title"
          validation="required"
          validation-name="Job title"
          @keyup="checkValidation"
          @blur="checkValidation"
        />

        <FormulateInput
          id="clubName"
          name="clubName"
          type="text"
          label="Club Name"
          read-only="true"
          disabled="true"
        />

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

import { notifyApiError } from "utilities/apiErrorHandler";
import ContainerHeader from "./ContainerHeader";
import ReferredBy from "./ReferredBy";
import PreviousButton from "./PreviousButton";
import NextButton from "./NextButton";

export default {
  name: "ClubAmbassadorStepTwo",
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
      inviteCode: new URLSearchParams(document.location.search).get(
        "invite_code"
      ),
      genderOptions: ["Female", "Male", "Non-binary", "Prefer not to say"],
      hasValidationErrors: true,
    };
  },
  async created() {
    await this.getClubName();
  },
  methods: {
    async getClubName() {
      try {
        const response = await axios.get("/api/registration/club_name", {
          params: { invite_code: this.inviteCode },
        });

        document.getElementById("clubName").value = response.data.clubName;
      } catch (error) {
        notifyApiError({
          error,
          context: "[REGISTRATION] Error getting club name",
        });
      }
    },
    checkValidation() {
      const validationErrorMessages = Array.from(
        document.getElementsByClassName("validation-error-message")
      ).map((element) => element.innerText);

      if (
        document.getElementById("firstName").value.length === 0 ||
        document.getElementById("lastName").value.length === 0 ||
        !document.getElementById("meetsMinimumAgeRequirement").checked ||
        document.getElementById("clubAmbassadorJobTitle").value.length === 0 ||
        (document.getElementById("phoneNumber").value.length > 0 &&
          validationErrorMessages.some((message) => {
            return message.indexOf("Phone number is invalid") >= 0;
          })) ||
        validationErrorMessages.some((message) => {
          return (
            message.indexOf("years old to participate") >= 0 ||
            message.indexOf("Personal summary must be at least") >= 0
          );
        })
      ) {
        this.hasValidationErrors = true;
      } else {
        this.hasValidationErrors = false;
      }
    },
  },
};
</script>
