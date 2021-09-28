<template>
  <div id="step-two">
    <ContainerHeader header-text="Basic Profile"/>

    <div id="student-information" class="form-wrapper">

      <h2 v-if="formValues.profileType === 'mentor'" class="registration-title">Mentor Information</h2>
      <h2 v-else class="registration-title">Student Information</h2>

      <div class="formulate-input-wrapper name-group">
        <FormulateInput
            name="firstName"
            type="text"
            label="First Name"
            placeholder="First Name"
            validation="required"
            class="flex-grow pr-2"
        />

        <FormulateInput
            name="lastName"
            type="text"
            label="Last Name"
            placeholder="Last Name"
            validation="required"
            class="flex-grow pl-2"

        />
      </div>

      <FormulateInput
          type="date"
          name="birthday"
          label="Birthday"
          placeholder="Student Birthday"
          error-behavior="live"
          validation="required"
      />

      <FormulateInput
          :name="formValues.profileType === 'mentor' ? 'companyName' : 'schoolName'"
          type="text"
          :label="formValues.profileType === 'mentor' ? 'Company Name' : 'School Name'"
          :placeholder="formValues.profileType === 'mentor' ? 'Company Name' : 'School Name'"
          validation="required"
      />

      <FormulateInput
          v-if="formValues.profileType === 'mentor'"
          name="jobTitle"
          type="text"
          label="Job Title"
          placeholder="Job Title"
          validation="required"
      />

      <FormulateInput
          v-if="formValues.profileType === 'mentor'"
          :options="mentorTypeOptions"
          type="select"
          placeholder="Select an option"
          label="As a mentor you may call me a ..."
          id="mentorType"
          input-class="mentorSelectClass"
      />
    </div>

    <div id="mentor-information" class="form-wrapper" v-if="formValues.profileType === 'mentor'">
      <h2 class="registration-title">Skills & Interests</h2>

      <FormulateInput
          :options="mentorProfileExpertiseOptions"
          type="checkbox"
          id="mentorExpertise"
      />

      <h2 class="registration-title">Set your personal summary</h2>
      <p class="text-left">Add a description of yourself to your profile to help students get to know you. You can change this later.</p>

      <FormulateInput
          name="mentorSummary"
          type="textarea"
          validation="required|min:100,length"
      />

    </div>

    <div id="parent-information" class="form-wrapper" v-if="formValues.profileType !== 'mentor'">
      <h2 class="registration-title">Parent Information</h2>

      <div class="formulate-input-wrapper name-group">
        <FormulateInput
            name="parentFirstName"
            type="text"
            label="First Name"
            placeholder="Parent First Name"
            validation="required"
            class="flex-grow pr-2"
        />

        <FormulateInput
            name="parentLastName"
            type="text"
            label="Last Name"
            placeholder="Parent Last Name"
            validation="required"
            class="flex-grow pl-2"
        />
      </div>

      <FormulateInput
          v-if="formValues.profileType === 'parent'"
          name="parentEmail"
          type="email"
          label="Parent Email Address"
          placeholder="Parent Email address"
          validation="required|email"
          :value="formValues.profileType === 'parent' ? formValues.parentEmail : ''"
      />

      <FormulateInput
          name="technovation-hear-about"
          type="text"
          label="How did you hear about Technovation? (Optional)"
      />

    </div>
  </div>
</template>

<script>
import ContainerHeader from "./ContainerHeader";
export default {
  name: "StepTwo",
  components: {ContainerHeader},
  props: ['formValues'],

  data () {
    return {
      mentorTypeOptions: [
        'Industry professional',
        'Educator',
        'Parent',
        'Past Technovation student',
      ],
      mentorProfileExpertiseOptions: ['Coding',
        'Experience with Java',
        'Business / entrepreneurship',
        'Project Management',
        'Marketing',
        'Design']
    }
  }
}
</script>

<style scoped>
  .login-form {
    padding: 2em;
  }

  .login-form::v-deep .formulate-input .formulate-input-element {
    max-width: none;
  }
</style>