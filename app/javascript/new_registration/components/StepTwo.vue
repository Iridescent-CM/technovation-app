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
          name="schoolName"
          type="text"
          label="School Name"
          placeholder="School Name"
          validation="required"
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
  props: ['formValues']
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