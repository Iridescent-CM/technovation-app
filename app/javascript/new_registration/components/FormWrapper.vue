<template>
  <FormulateForm
    class="registration-container pb-6"
    v-model="formValues"
    @submit="submitHandler"
    #default="{ isLoading }"
    :form-errors="formErrors"
    :errors="inputErrors"
    id="registration-form"
  >

    <div v-show="step === 1">
      <StepOne :form-values="formValues" @next="next" />
    </div>

    <div v-show="step === 2">
      <MentorStepTwo v-if="formValues.profileType === 'mentor'"
        :form-values="formValues"
        @next="next"
        @prev="prev"
      />
      <JudgeStepTwo v-else-if="formValues.profileType === 'judge'"
        :form-values="formValues"
        @next="next"
        @prev="prev"
      />
      <ChapterAmbassadorStepTwo v-else-if="formValues.profileType === 'chapter_ambassador'"
        :form-values="formValues"
        @next="next"
        @prev="prev"
      />
      <ClubAmbassadorStepTwo v-else-if="formValues.profileType === 'club_ambassador'"
        :form-values="formValues"
        @next="next"
        @prev="prev"
      />
      <StudentStepTwo v-else
        :form-values="formValues"
        @next="next"
        @prev="prev"
      />
    </div>

    <div v-show="step === 3">
      <StepThree :form-values="formValues" @next="next" @prev="prev" />
    </div>

    <div v-show="step === 4">
      <StepFour :form-values="formValues" :isLoading="isLoading" @prev="prev" />

      <FormulateErrors />
    </div>
  </FormulateForm>
</template>

<script>
import axios from 'axios';

import StepOne from './StepOne';
import MentorStepTwo from './MentorStepTwo';
import StudentStepTwo from './StudentStepTwo';
import JudgeStepTwo from "./JudgeStepTwo";
import ChapterAmbassadorStepTwo from "./ChapterAmbassadorStepTwo";
import ClubAmbassadorStepTwo from "./ClubAmbassadorStepTwo";
import StepThree from './StepThree';
import StepFour from './StepFour';

export default {
  name: "FormWrapper.vue",
  components:{
    StepOne,
    MentorStepTwo,
    StudentStepTwo,
    JudgeStepTwo,
    ChapterAmbassadorStepTwo,
    ClubAmbassadorStepTwo,
    StepThree,
    StepFour
  },
  data(){
    return {
      step: 1,
      formValues: {},
      formErrors: [],
      inputErrors: {},
      mentorProfileExpertiseOptions: []
    }
  },
  created() {
    window.addEventListener('keypress', this.onKeyPress);
  },
  beforeDestroy() {
    window.removeEventListener('keypress', this.onKeyPress);
  },
  methods: {
    prev() {
      this.step--;
      this.scrollToTopOfForm();
    },
    next() {
      this.step++;
      this.scrollToTopOfForm();
    },
    scrollToTopOfForm() {
      document.getElementById('registration-form').scrollIntoView();
    },
    onKeyPress(e) {
      if (e.which === 13) {
        e.preventDefault();
      }
    },
    async submitHandler (data) {
      const csrfTokenMetaTag = document.querySelector('meta[name="csrf-token"]')
      const inviteCode = new URLSearchParams(document.location.search).get('invite_code')

      let config = {
        headers: {
          'X-Requested-With': 'XMLHttpRequest',
          'X-Csrf-Token' : csrfTokenMetaTag.getAttribute('content')
        }
      }

      try {
        await axios.post('/new-registration', Object.assign(data, {inviteCode}), config)

        switch(data.profileType) {
          case 'student':
          case 'parent':
            window.location.href = '/student/profile'
            break
          case 'mentor':
            window.location.href = '/mentor/dashboard'
            break
          case 'judge':
            window.location.href = '/judge/dashboard'
            break
          case 'chapter_ambassador':
            window.location.href = '/chapter_ambassador/dashboard'
            break
          case 'club_ambassador':
            window.location.href = '/club_ambassador/dashboard'
            break
        }
      }
      catch(error) {
        if(error.response) {
          this.formErrors = error.response.data.full_error_messages
          this.inputErrors = error.response.data.errors
        }
      }
    }
  }
}
</script>
