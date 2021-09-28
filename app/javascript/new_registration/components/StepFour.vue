<template>

  <div id="step-four">
    <ContainerHeader header-text="Set your email and password"/>

    <div id="email-password" class="form-wrapper">
      <h1 class="text-tg-green text-2xl text-left mb-6" v-if="formValues.profileType === 'parent'">This is an account for beginners division</h1>
      <h1 class="text-tg-green text-2xl text-left mb-6" v-if="formValues.profileType === 'mentor'">This is an account for a mentor</h1>

      <FormulateInput
          name="accountEmail"
          type="email"
          :label="formValues.profileType === 'parent' ? 'Parent Email Address' : 'Email Address'"
          placeholder="Email address"
          validation="required"
          class="flex-grow "
          id="accountEmail"
          v-model="setAccountEmailForParentProfile"
          :validation-messages="{required: 'Email address is required.'}"
      />

      <p class="text-left text-sm mb-12">Please choose a personal, permanent email. A school or company email might block us from sending important messages to you.</p>

      <div class="double-wide">
        <FormulateInput
            name="password"
            type="password"
            label="Password"
            placeholder="At least 8 characters"
            validation="required"
        />
      </div>

    </div>

  </div>

</template>

<script>
import ContainerHeader from "./ContainerHeader";
export default {
  name: "StepFour",
  components: {
    ContainerHeader
  },
  props: ['formValues'],
  computed:{
    setAccountEmailForParentProfile: {
      get(){
        if (this.formValues.parentEmail && this.formValues.profileType === "parent") {
          return this.formValues.parentEmail
        } else {
          return  this.formValues.accountEmail
        }
      },
      set(accountEmailVal){

        if (this.formValues.parentEmail && this.formValues.profileType === "parent") {
          document.getElementById("accountEmail").disabled = true
        } else{
          document.getElementById("accountEmail").disabled = false
        }

        this.formValues.accountEmail = accountEmailVal
      }
    }
  }
}
</script>

<style scoped>
</style>