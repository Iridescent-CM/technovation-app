<template>
  <div id="step-one">
    <ContainerHeader header-text="Your Participant Type" />
    <div id="profile-type" class="form-wrapper">
      <div v-if="registrationInvite.isValid == false">
        <div class="border-l-2 border-red-700 bg-red-50 p-2 mb-4">
          <p v-if="anyDisabledProfileTypes == false" class="text-left">
            This invitation is no longer valid, but you can still register below.
          </p>
          <p v-else>
            This invitation is no longer valid.
          </p>
        </div>
      </div>

      <div v-if="anyDisabledProfileTypes" class="border-l-2 border-red-700 bg-red-50 p-2 mb-4">
        <p class="text-left text-sm">
          Registration is currently closed for {{ this.disabledProfileTypes }}.
        </p>
      </div>

      <div v-if="Object.keys(registrationInvite).length !== 0">
        <div v-if="registrationInvite.isValid == true">
          <h2 class="registration-title">
            Welcome to Technovation Girls!
          </h2>

          <div class=" border-l-2 border-energetic-blue bg-blue-50 p-2 mb-8">
            <p class="text-left">
              You have been invited to join Technovation Girls as a <strong>{{ registrationInvite.friendlyProfileType }}</strong>!
            </p>
          </div>
        </div>
      </div>

      <div v-else>
        <h2 class="registration-title">
          Technovation Girls is a free program that empowers
          <a href="https://www.technovation.org/diversity-equity-inclusion-statement/" target="_blank">
            <em>girls</em>
          </a>
          to be leaders. How will you participate?
        </h2>
      </div>

      <FormulateInput
        label-position="before"
        type="radio"
        class="profile-type"
        :options="profileTypes"
        name="profileType"
        validation="required"
        @input="hasValidationErrors = false"
      />

      <p v-if="displayDivisionCutoffDescription()" class="italic text-sm">
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
      registrationInvite: {},
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
    async getRegistrationInvite() {
      const inviteCode = new URLSearchParams(document.location.search).get('invite_code')

      if (inviteCode == null) {
        return
      }

      try {
        const response = await axios.get(`/api/registration_invites/${inviteCode}`)

        this.registrationInvite = response.data
      }
      catch(error) {
        airbrake.notify({
          error: `[REGISTRATION] Error getting registration invite details - ${error.response.data}`
        })
      }
    },
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

      if (this.registrationInvite.isValid && this.registrationInvite.profileType == 'chapter_ambassador') {
        this.profileTypes.push(this.chapterAmbassadorProfileType())
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
    preSelectInvitedProfileType() {
      document.getElementById(`${this.registrationInvite.profileType}`).click()
      document.getElementById(`${this.registrationInvite.profileType}`).checked = true

      this.hasValidationErrors = false
    },
    disableNonInvitedProfileTypes() {
      const profileTypeRadioButtons = document.querySelectorAll(`#profile-type input[type="radio"]:not(#${this.registrationInvite.profileType}`)
      const profileTypeImages = document.querySelectorAll(`#profile-type img:not(.${this.registrationInvite.profileType})`)
      const profileTypeText = document.querySelectorAll(`#profile-type span:not(.${this.registrationInvite.profileType})`)

      profileTypeRadioButtons.forEach(profileType => {
        profileType.disabled = true
        profileType.classList.add("disabled")
      });

      profileTypeImages.forEach(profileType => {
        profileType.classList.add("disabled")
      })

      profileTypeText.forEach(profileType => {
        profileType.classList.add("disabled")
      })
    },
    studentProfileType() {
      return {
        label: `<img src="${require('signup/myTG-student.png')}" alt="" class="student"> <span class="student s1-label-text">I am registering myself and am 13-18 years old*</span>`,
        value: 'student',
        id: 'student'
      }
    },
    parentProfileType() {
      return {
        label: `<img src="${require('signup/myTG-parent.png')}" alt="" class="parent"> <span class="parent s1-label-text">I am registering my 8-12 year old* daughter</span>`,
        value: 'parent',
        id: 'parent'
      }
    },
    mentorProfileType() {
      return {
        label: `<img src="${require('signup/myTG-mentor.png')}" alt="" class="mentor"> <span class="mentor s1-label-text">I am over 18 years old and will guide a team</span>`,
        value: 'mentor',
        id: 'mentor'
      }
    },
    judgeProfileType() {
      return {
        label: `<img src="${require('signup/myTG-mentor.png')}" alt="" class="judge"> <span class="judge s1-label-text">I am over 18 years old and will <span class="judge font-bold">judge submissions</span>`,
        value: 'judge',
        id: 'judge'
      }
    },
    chapterAmbassadorProfileType() {
      return {
        label: `<img src="${require('signup/myTG-mentor.png')}" alt="" class="chapter_ambassador"> <span class="chapter_ambassador s1-label-text">Chapter Ambassador</span>`,
        value: 'chapter_ambassador',
        id: 'chapter_ambassador'
      }
    },
    displayDivisionCutoffDescription() {
      return (this.isStudentRegistrationOpen && typeof this.registrationInvite =='undefined') || (this.registrationInvite.isValid == true && this.registrationInvite.profileType == 'student' || this.registrationInvite.isValid == false)
    }
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
    await this.getRegistrationInvite()
    await this.getRegistrationSettings()
    await this.setupProfileTypes()
    await this.setupDisabledProfileTypes()

    if (this.registrationInvite.isValid == true) {
      this.preSelectInvitedProfileType()
      this.disableNonInvitedProfileTypes()
    }
  }
}
</script>
