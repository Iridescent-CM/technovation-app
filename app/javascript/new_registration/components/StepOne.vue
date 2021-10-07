<template>
  <div id="step-one">
    <ContainerHeader header-text="Your Profile Type"/>

    <div id="profile-type" class="form-wrapper">
      <h2 class="registration-title">I am a...</h2>

        <FormulateInput
            label-position="before"
            type="radio"
            class="profile-type"
            :options="options"
            name="profileType"
            validation="required"
        />
    </div>
      <!--      <pre class="mt-8 p-2 bg-gray-200 whitespace-pre text-sm">{{ values }}</pre>-->
  </div>
</template>


<script>
import ContainerHeader from "./ContainerHeader";
export default {
  name: 'StepOne',
  components: {ContainerHeader},
  data() {
    return {
      values: {},
      options: [
        {
          label: `<img src="${require('../assets/myTG-parent.png').default}" alt=""> <span class="s1-label-text">PARENT <br> Registering a daughter 8-12 years old</span>`,
          value: "parent",
        },
        {
          label: `<img src="${require('../assets/myTG-student.png').default}" alt=""><span class="s1-label-text"> STUDENT <br> 13 - 18 year old female-identifying student</span>`,
          value: "student",
        },
        {
          label: `<img src="${require('../assets/myTG-mentor.png').default}" alt=""> <span class="s1-label-text">MENTOR <br> Over 18 years old who wants to help guide a team of girls</span>`,
          value: "mentor",
        }
      ],
    };
  },
  props: ['formValues']
}
</script>

<style>
/*.formulate-input-group {*/
/*  display: flex;*/
/*  justify-content: space-evenly;*/
/*}*/
/*.profile-type img {*/
/*  width: 7em;*/
/*  !*margin-right: 0.5em;*!*/
/*  margin: auto;*/
/*}*/

/*[data-classification="box"] .formulate-input-wrapper {*/
/*  display: flex;*/
/*  align-items: center;*/
/*}*/



/*HORIZONTAL RADIO BUTTONS*/
.formulate-input-group-item {
  display: flex;
}
.profile-type img {
  width: 7em;
  margin-left: 1rem;
  margin-right: 1.5rem;
}

[data-classification="box"] .formulate-input-wrapper {
  display: flex;
  align-items: center;
}

.input-label-text{
  display: flex;
  align-items: center;
}

.s1-label-text{
  @apply text-lg text-left
}
</style>