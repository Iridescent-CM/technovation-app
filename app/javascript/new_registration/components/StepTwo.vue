<template>
  <div id="step-two">
    <ContainerHeader header-text="Basic Profile"/>

      <div v-if="formValues.profileType === 'mentor'" class="form-wrapper">
       <MentorStepTwo/>
      </div>
      <div v-else class="form-wrapper">
        <StudentStepTwo/>
      </div>

    <div class="form-wrapper">
      <FormulateInput
          name="referredBy"
          type="select"
          label="How did you hear about Technovation? (Optional)"
          :options="referralOptions"
          input-class="mentorSelectClass"
          id="referredBy"
          placeholder="Select an option"
      />
    </div>
  </div>
</template>

<script>
import ContainerHeader from "./ContainerHeader";
import MentorStepTwo from "./MentorStepTwo";
import StudentStepTwo from "./StudentStepTwo";
export default {
  name: "StepTwo",
  components: {
    ContainerHeader,
    MentorStepTwo,
    StudentStepTwo
  },
  props: ['formValues'],
  data () {
    return {
      referralOptions:[
        'Friend',
        'Colleague',
        'Article',
        'Internet',
        'Social media',
        'Print',
        'Web search',
        'Teacher',
        'Parent/family',
        'Company email',
        'Other',
      ],
    }
  }
}
</script>

<style>
  .login-form {
    padding: 2em;
  }

  .login-form::v-deep .formulate-input .formulate-input-element {
    max-width: none;
  }

  #step-two input[type='checkbox'] {
    @apply w-5 focus:border-green-500
  }

  .mentorSelectClass, #mentorSummary{
    @apply border bg-white border-gray-400 rounded px-3 py-2 leading-none focus:border-green-500 outline-none w-full mb-1
  }
</style>