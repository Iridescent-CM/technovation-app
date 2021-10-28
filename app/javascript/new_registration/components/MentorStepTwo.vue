<template>
  <div id="step-two-mentor">
    <h2 class="registration-title">Mentor Information</h2>

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
        :options="genderOptions"
        type="select"
        placeholder="Select an option"
        label="Gender Identity"
        id="genderIdentity"
        input-class="mentorSelectClass"
    />

    <FormulateInput
        type="date"
        name="birthday"
        label="Birthday"
        placeholder="Birthday"
        validation="required"
    />

    <FormulateInput
        name="companyName"
        type="text"
        label="Company Name"
        placeholder="Company Name"
        validation="required"
    />

    <FormulateInput
        name="jobTitle"
        type="text"
        label="Job Title"
        placeholder="Job Title"
        validation="required"
    />

    <FormulateInput
        :options="mentorTypeOptions"
        type="select"
        placeholder="Select an option"
        label="As a mentor you may call me a ..."
        id="mentorType"
        input-class="mentorSelectClass"
    />

    <div id="mentor-information">
      <h2 class="registration-title">Skills & Interests</h2>
      <FormulateInput
          :options="mentorProfileExpertiseOptions"
          type="checkbox"
          id="mentorExpertise"
      />
    </div>

    <div class="mentor-information">
      <h2 class="registration-title">Set your personal summary</h2>
      <p class="text-left">Add a description of yourself to your profile to help students get to know you. You can change this later.</p>
      <FormulateInput
          name="mentorSummary"
          type="textarea"
          validation="required|min:100,length"
          id="mentorSummary"
      />
    </div>
  </div>
</template>

<script>
  export default {
  name: "MentorStepTwo",
  props: ['formValues'],
    data () {
      return {
        genderOptions: [
          'Female',
          'Male',
          'Non-binary',
          'Prefer not to say'
        ],
        mentorTypeOptions: [
          {value: 0, label: 'Industry professional'},
          {value: 1, label: 'Educator'},
          {value: 2, label: 'Parent'},
          {value: 3, label: 'Past Technovation student'}
        ],
        mentorProfileExpertiseOptions: [
          {value: 2, label: 'Coding'},
          {value: 8, label: 'Experience with Java'},
          {value: 10, label: 'Business / entrepreneurship'},
          {value: 4, label: 'Project Management'},
          {value: 6, label: 'Marketing'},
          {value: 7, label: 'Design'}
        ]
      }
    }
  }
</script>