<template>
  <div id="step-one">
    <ContainerHeader header-text="Your Profile Type" />

    <div id="profile-type" class="form-wrapper">
      <h2 class="registration-title">
        Technovation Girls is a free program that empowers
        <a href="https://www.technovation.org/diversity-equity-inclusion-statement/" target="_blank">
          <em>girls</em>
        </a>
        to be leaders. How will you participate?
      </h2>

      <p class="italic text-sm text-red-500 my-4">
        Registration for the 2022 season is now closed for students and mentors.
      </p>

      <FormulateInput
        label-position="before"
        type="radio"
        class="profile-type"
        :options="options"
        name="profileType"
        validation="required"
        @input="hasValidationErrors = false"
      />

      <p class="italic text-sm">
        <!-- *As of <strong>{{ divisionCutoffDate }}</strong>. -->
        <!-- For example, if you turn 13 on July 28, 2022, you will need to select -->
        <!-- “I am registering myself and am 13-18 years old.” -->
      </p>
    </div>

    <NextButton @next="$emit('next')" :disabled="hasValidationErrors" />
  </div>
</template>


<script>
import ContainerHeader from "./ContainerHeader";
import NextButton from "./NextButton";
import { divisionCutoffDateFormatted } from "../../utilities/technovation-dates.js"

export default {
  name: 'StepOne',
  components: {ContainerHeader, NextButton},
  data() {
    return {
      values: {},
      options: [
        //{
        //  label: `<img src="${require('signup/myTG-parent.png')}" alt=""> <span class="s1-label-text">I am registering my 8-12 year old* daughter</span>`,
        //  value: "parent",
        //},
        //{
        //  label: `<img src="${require('signup/myTG-student.png')}" alt=""><span class="s1-label-text">I am registering myself and am 13-18 years old*</span>`,
        //  value: "student",
        //},
        //{
        //  label: `<img src="${require('signup/myTG-mentor.png')}" alt=""> <span class="s1-label-text">I am over 18 years old and will guide a team</span>`,
        //  value: "mentor",
        //},
        {
          label: `<img src="${require('signup/myTG-mentor.png')}" alt=""> <span class="s1-label-text">I am over 18 years old and will <span class="font-bold">judge submissions</span></span>`,
          value: "judge",
        }
      ],
      hasValidationErrors: true
    };
  },
  computed: {
    divisionCutoffDate: divisionCutoffDateFormatted
  },
  props: {
    formValues: {
      type: Object,
      required: true
    }
  }
}
</script>
