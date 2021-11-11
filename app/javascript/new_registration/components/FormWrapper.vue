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
      <StepOne :form-values="formValues"/>
      <NextButton @next="next()"/>
    </div>

    <div v-show="step === 2">
      <StepTwo :form-values="formValues"/>
      <div class="registration-btn-wrapper">
        <PreviousButton @prev="prev()"/>
        <NextButton @next="next()"/>
      </div>
    </div>

    <div v-show="step === 3">
      <StepThree :form-values="formValues"/>
      <div class="registration-btn-wrapper">
        <PreviousButton @prev="prev()"/>
        <NextButton @next="next()"/>
      </div>
    </div>

    <div v-show="step === 4">
      <StepFour :form-values="formValues"/>

      <FormulateErrors />

      <div class="registration-btn-wrapper">
        <PreviousButton @prev="prev()"/>
        <FormulateInput
            type="submit"
            :disabled="isLoading"
            :label="isLoading ? 'Submitting...' : 'Submit this form'"
            class="registration-btns"
        />
      </div>

    </div>

    <pre
        class="code"
        v-text="formValues"
    />
  </FormulateForm>
</template>

<script>
import StepOne from "./StepOne";
import StepTwo from "./StepTwo";
import StepThree from "./StepThree";
import StepFour from "./StepFour";
import PreviousButton from "./PreviousButton";
import NextButton from "./NextButton";
import axios from "axios";
export default {
  name: "FormWrapper.vue",
  components:{
    StepOne,
    StepTwo,
    StepThree,
    StepFour,
    PreviousButton,
    NextButton
  },
  data(){
    return {
      step: 1,
      formValues: {},
      inputErrors: {}
    }
  },
  methods: {
    prev() {
      this.step--;
    },
    next() {
      this.step++;
    },
    async submitHandler (data) {
      console.log(data);
      const csrfTokenMetaTag = document.querySelector('meta[name="csrf-token"]')

      let config = {
        headers: {
          'X-Requested-With': 'XMLHttpRequest',
          'X-Csrf-Token' : csrfTokenMetaTag.getAttribute('content')
        }
      }

      // not a parent
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

<style scoped>
.registration-btn-wrapper{
  @apply flex p-6 justify-between;
}
</style>
