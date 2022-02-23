<template>
  <div class="form-wrapper">
    <FormulateInput
      name="referredBy"
      type="select"
      label="How did you hear about Technovation? (Optional)"
      :options="referralOptions"
      input-class="mentorSelectClass"
      id="referredBy"
      placeholder="Select an option"
      v-model="referralOption"
    />

    <FormulateInput
      name="referredByOther"
      id="referredByOther"
      type="text"
      label="Who referred you?"
      placeholder="Referred by"
      v-show="referralOption == 11"
    />
  </div>
</template>

<script>
export default {
  data () {
    return {
      referralOption: 0,
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
        {value: 11, label: 'Other'}
      ]
    }
  }
}
</script>
