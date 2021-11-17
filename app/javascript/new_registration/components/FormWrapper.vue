<template>
  <FormulateForm
      class="registration-container pb-6"
      v-model="formValues"
      @submit="submitHandler"
      #default="{ isLoading }"
      :errors="inputErrors"
      :invalid-message="invalidMessage"
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
import StepOne from "./StepOne";
import MentorStepTwo from "./MentorStepTwo";
import StudentStepTwo from "./StudentStepTwo";
import StepThree from "./StepThree";
import StepFour from "./StepFour";
import axios from "axios";

export default {
  name: "FormWrapper.vue",
  components:{
    StepOne,
    MentorStepTwo,
    StudentStepTwo,
    StepThree,
    StepFour
  },
  data(){
    return {
      step: 1,
      formValues: {},
      inputErrors: {}
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
    },
    next() {
      this.step++;
    },
    onKeyPress(e) {
      if (e.which === 13) {
        e.preventDefault();
      }
    },
    async submitHandler (data) {
      const csrfTokenMetaTag = document.querySelector('meta[name="csrf-token"]')

      let config = {
        headers: {
          'X-Requested-With': 'XMLHttpRequest',
          'X-Csrf-Token' : csrfTokenMetaTag.getAttribute('content')
        }
      }

      if(data.profileType !== "parent"){
        data.parentEmail = false
      }
      try {
        await axios.post('/new-registration', data, config)

        switch(data.profileType) {
          case 'student':
          case 'parent':
            window.location.href = '/student/dashboard'
          case 'mentor':
            window.location.href = '/mentor/dashboard'
        }
      }
      catch(error) {
        if(error.response) {
          this.inputErrors = error.response.data.errors
        }
      }
    },
    invalidMessage(fields) {
      const fieldNames = Object.keys(fields)
      const listOfNames = fieldNames.map(fieldName => {
        return fieldName.replace(/([a-z](?=[A-Z]))/g, '$1 ').replace(/^./, function(str){ return str.toUpperCase(); })
      })

      return `Invalid fields: ${listOfNames.map(name => ` ${name}`)}`
    }
  }
}
</script>
