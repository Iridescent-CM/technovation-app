<template>
  <div id="step-two">
    <ContainerHeader header-text="Basic Profile"/>

      <div v-if="formValues.profileType === 'mentor'" class="form-wrapper">
       <MentorStepTwo/>
      </div>
      <div v-else class="form-wrapper">
        <StudentStepTwo :form-values="formValues"/>
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
