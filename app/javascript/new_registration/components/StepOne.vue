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

      <div v-if="anyDisabledProfileTypes" class="border-l-2 border-red-700 bg-red-50 p-2 my-8">
        <p class="text-left text-sm">
          Registration is currently closed for {{ this.disabledProfileTypes }}.
        </p>
      </div>

      <p class="italic text-sm text-red-500 my-4">
      </p>

      <FormulateInput
        label-position="before"
        type="radio"
        class="profile-type"
        :options="profileTypes"
        name="profileType"
        validation="required"
        @input="hasValidationErrors = false"
      />

      <p v-if="this.isStudentRegistrationOpen" class="italic text-sm">
        *As of <strong>{{ divisionCutoffDate }}</strong>.
        For example, if you turn 13 on {{ exampleStudentBirthday }}, you will need to select
        “I am registering myself and am 13-18 years old.”
      </p>
    </div>

    <NextButton @next="$emit('next')" :disabled="hasValidationErrors" />
  </div>
</template>

<script>
import axios from 'axios'

import { airbrake } from 'utilities/utilities'
import ContainerHeader from './ContainerHeader'
import NextButton from './NextButton'
import { divisionCutoffDateFormatted } from '../../utilities/technovation-dates.js'
import { exampleStudentBirthday } from '../../utilities/age-helpers.js'

export default {
  name: 'StepOne',
  components: {ContainerHeader, NextButton},
  data() {
    return {
      values: {},
      profileTypes: [],
      isStudentRegistrationOpen: false,
      isMentorRegistrationOpen: false,
      isJudgeRegistrationOpen: false,
      anyDisabledProfileTypes: false,
      disabledProfileTypes: '',
      hasValidationErrors: true
    }
  },
  methods: {
    async getRegistrationSettings() {
      try {
        const response = await axios.get('/api/registration_settings')

        this.isStudentRegistrationOpen = response.data.isStudentRegistrationOpen
        this.isMentorRegistrationOpen = response.data.isMentorRegistrationOpen
        this.isJudgeRegistrationOpen = response.data.isJudgeRegistrationOpen
      }
      catch(error) {
        airbrake.notify({
          error: `[REGISTRATION] Error getting registration settings - ${error.response.data}`
        })
      }
    },
    setupProfileTypes() {
      if (this.isStudentRegistrationOpen) {
        this.profileTypes.push(this.studentProfileType())
        this.profileTypes.push(this.parentProfileType())
      }

      if (this.isMentorRegistrationOpen) {
        this.profileTypes.push(this.mentorProfileType())
      }

      if (this.isJudgeRegistrationOpen) {
        this.profileTypes.push(this.judgeProfileType())
      }
    },
    setupDisabledProfileTypes() {
      let disabledProfiles = []

      if (!this.isStudentRegistrationOpen) {
        disabledProfiles.push('students')
      }

      if (!this.isMentorRegistrationOpen) {
        disabledProfiles.push('mentors')
      }

      if (!this.isJudgeRegistrationOpen) {
        disabledProfiles.push('judges')
      }

      if (disabledProfiles.length > 0) {
        this.anyDisabledProfileTypes = true
      }

      this.disabledProfileTypes = new Intl.ListFormat('en', { style: 'long', type: 'conjunction' }).format(disabledProfiles)
    },
    studentProfileType() {
      return {
        label: `<img src="${require('signup/myTG-student.png')}" alt=""><span class="s1-label-text">I am registering myself and am 13-18 years old*</span>`,
        value: 'student'
      }
    },
    parentProfileType() {
      return {
        label: `<img src="${require('signup/myTG-parent.png')}" alt=""> <span class="s1-label-text">I am registering my 8-12 year old* daughter</span>`,
        value: 'parent'
      }
    },
    mentorProfileType() {
      return {
        label: `<img src="${require('signup/myTG-mentor.png')}" alt=""> <span class="s1-label-text">I am over 18 years old and will guide a team</span>`,
          value: 'mentor'
      }
    },
    judgeProfileType() {
      return {
        label: `<img src="${require('signup/myTG-mentor.png')}" alt=""> <span class="s1-label-text">I am over 18 years old and will <span class="font-bold">judge submissions</span></span>`,
        value: 'judge'
      }
    },
  },
  computed: {
    divisionCutoffDate: divisionCutoffDateFormatted,
    exampleStudentBirthday
  },
  props: {
    formValues: {
      type: Object,
      required: true
    }
  },
  async created() {
    await this.getRegistrationSettings()

    this.setupProfileTypes()
    this.setupDisabledProfileTypes()
  }
}
</script>
