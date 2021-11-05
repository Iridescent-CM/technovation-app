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
        {value: 0, label: 'Friend'},
        {value: 1, label: 'Colleague'},
        {value: 2, label: 'Article'},
        {value: 3, label: 'Internet'},
        {value: 4, label: 'Social media'},
        {value: 5, label: 'Print'},
        {value: 6, label: 'Web search'},
        {value: 7, label: 'Teacher'},
        {value: 8, label: 'Parent/family'},
        {value: 9, label: 'Company email'},
        {value: 11, label: 'Other'},
      ],
    }
  }
}
</script>
