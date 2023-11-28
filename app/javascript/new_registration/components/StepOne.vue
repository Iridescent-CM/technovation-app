<template>
  <div id="step-one">
    <ContainerHeader header-text="How will you participate?" />
    <div id="profile-type" class="form-wrapper">
      <div v-if="this.errorMessage.length > 0">
        <div class="border-l-2 border-red-700 bg-red-50 p-2 mb-4">
          <p class="text-left text-rose-900">
            {{ this.errorMessage }}
          </p>
        </div>
      </div>

      <div v-if="(this.inviteCode != null || this.teamInviteCode != null) && this.successMessage.length > 0">
        <h2 class="registration-title">
          Welcome to Technovation Girls!
        </h2>

        <div class=" border-l-2 border-energetic-blue bg-blue-50 p-2 mb-8">
          <p class="text-left">
            {{ this.successMessage }}
          </p>
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
      profileTypes: [],
      isStudentRegistrationOpen: false,
      isParentRegistrationOpen: false,
      isMentorRegistrationOpen: false,
      isJudgeRegistrationOpen: false,
      isChapterAmbassadorRegistrationOpen: false,
      invitedRegistrationProfileType: '',
      successMessage: '',
      errorMessage: '',
      inviteCode:  new URLSearchParams(document.location.search).get('invite_code'),
      teamInviteCode: new URLSearchParams(document.location.search).get('team_invite_code'),
      hasValidationErrors: true
    }
  },
  methods: {
    async getRegistrationSettings() {
      try {
        const response = await axios.get('/api/registration/settings', {
          params: { invite_code: this.inviteCode, team_invite_code: this.teamInviteCode }
        })

        this.isStudentRegistrationOpen = response.data.isStudentRegistrationOpen
        this.isParentRegistrationOpen = response.data.isParentRegistrationOpen
        this.isMentorRegistrationOpen = response.data.isMentorRegistrationOpen
        this.isJudgeRegistrationOpen = response.data.isJudgeRegistrationOpen
        this.isChapterAmbassadorRegistrationOpen = response.data.isChapterAmbassadorRegistrationOpen
        this.invitedRegistrationProfileType = response.data.invitedRegistrationProfileType
        this.successMessage = response.data.successMessage
        this.errorMessage = response.data.errorMessage
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
      }

      if (this.isParentRegistrationOpen) {
        this.profileTypes.push(this.parentProfileType())
      }

      if (this.isMentorRegistrationOpen) {
        this.profileTypes.push(this.mentorProfileType())
      }

      if (this.isJudgeRegistrationOpen) {
        this.profileTypes.push(this.judgeProfileType())
      }

      if (this.isChapterAmbassadorRegistrationOpen) {
        this.profileTypes.push(this.chapterAmbassadorProfileType())
      }
    },
    preSelectInvitedProfileType() {
      document.getElementById(`${this.invitedRegistrationProfileType}`).click()
      document.getElementById(`${this.invitedRegistrationProfileType}`).checked = true

      this.hasValidationErrors = false
    },
    disableNonInvitedProfileTypes() {
      const profileTypeRadioButtons = document.querySelectorAll(`#profile-type input[type="radio"]:not(#${this.invitedRegistrationProfileType}`)
      const profileTypeImages = document.querySelectorAll(`#profile-type img:not(.${this.invitedRegistrationProfileType})`)
      const profileTypeText = document.querySelectorAll(`#profile-type span:not(.${this.invitedRegistrationProfileType})`)

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
        label: `<img src="${require('signup/student.png')}" alt="" class="student mb-2"> <span class="student s1-label-text">I am registering myself and am 13-18 years old*</span>`,
        value: 'student',
        id: 'student'
      }
    },
    parentProfileType() {
      return {
        label: `<img src="${require('signup/parent.png')}" alt="" class="parent mb-2"> <span class="parent s1-label-text">I am registering my 8-12 year old* daughter</span>`,
        value: 'parent',
        id: 'parent'
      }
    },
    mentorProfileType() {
      return {
        label: `<img src="${require('signup/mentor.png')}" alt="" class="mentor mb-2"> <span class="mentor s1-label-text">I am over 18 years old and will guide a team</span>`,
        value: 'mentor',
        id: 'mentor'
      }
    },
    judgeProfileType() {
      return {
        label: `<img src="${require('signup/judge.png')}" alt="" class="judge mb-2"> <span class="judge s1-label-text">I am over 18 years old and will <span class="judge font-bold">judge submissions</span>`,
        value: 'judge',
        id: 'judge'
      }
    },
    chapterAmbassadorProfileType() {
      return {
        label: `<img src="${require('signup/chapter-ambassador.png')}" alt="" class="chapter_ambassador mb-2"> <span class="chapter_ambassador s1-label-text">Chapter Ambassador</span>`,
        value: 'chapter_ambassador',
        id: 'chapter_ambassador'
      }
    },
    displayDivisionCutoffDescription() {
      return (this.isStudentRegistrationOpen)
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
    await this.getRegistrationSettings()
    await this.setupProfileTypes()

    if (this.invitedRegistrationProfileType.length > 0) {
      this.preSelectInvitedProfileType()
      this.disableNonInvitedProfileTypes()
    }
  }
}
</script>
