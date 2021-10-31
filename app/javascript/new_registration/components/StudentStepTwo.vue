<template>
  <div id="step-two-student">
    <h2 class="registration-title">Student Information</h2>

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
        placeholder="Birthday"
        validation="required"
    />

    <FormulateInput
        name="schoolName"
        type="text"
        label="School Name"
        placeholder="School Name"
        validation="required"
    />

    <div id="parent-information">
      <h2 class="registration-title">Parent Information</h2>

      <div class="formulate-input-wrapper name-group">
        <FormulateInput
            name="parentName"
            type="text"
            label="Name"
            placeholder="Parent Name"
            validation="required"
            class="flex-grow pr-2"
        />
      </div>

      <FormulateInput
          v-if="formValues.profileType === 'parent'"
          name="parentEmail"
          type="email"
          label="Parent Email Address"
          placeholder="Parent Email address"
          validation="required|email"
      />

      <FormulateInput
          v-else
          name="parentEmail"
          type="email"
          label="Parent Email Address (Optional)"
          placeholder="Parent Email address"
      />
    </div>
  </div>
</template>

<script>
export default {
  name: "StudentStepTwo",
  props: ['formValues']
}
</script>
