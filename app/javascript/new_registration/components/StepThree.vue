<template>
  <div class="step-three">
    <ContainerHeader header-text="Agree to our data use terms"/>

    <div id="data-use" class="form-wrapper text-left">

      <section class="contract-section" id="how">
        <h2 class="registration-title">How Technovation Uses Your Data</h2>
        <p>Please take a moment to read this before continuing registration. We have tried to make it very easy to understand. You can read our
          <a href="#">full terms of use.</a> Below is a summary.</p>
      </section>

      <hr class="contract-hr">

      <section class="contract-section mt-8">
        <p>Technovation Girls is owned by a non-profit organization called Technovation.</p>
      </section>

      <section class="contract-section" id="advertising">
        <h2 class="registration-title">No advertising</h2>
        <p>We will never use, share, rent, or sell your personal data to anyone to advertise to you, or to manipulate you.</p>
      </section>

      <section class="contract-section" id="personal-data">
        <h2 class="registration-title">Your personal data</h2>
        <p>We will only use your data to help guide you through the Technovation Girls program, and to learn how we can make the program better and easier for everyone. We may share your personal data and activity with a trusted volunteer manager in your region - who has been trained through a proper verification process - in order for them to support you and your team during the program.</p>
      </section>

      <section class="contract-section" id="newsletters">
        <h2 class="registration-title">Newsletters and informational email</h2>
        <p>You can unsubscribe from our newsletters about the curriculum and program at any time. This is different from informational emails about your account and team activity, which you will continue to receive.</p>
      </section>

      <section class="contract-section" id="deleting">
        <h2 class="registration-title">Deleting your account and data</h2>
        <p>You can delete your account and data, and get a copy of your data, at any time. Deleting your data will remove you from your team and our program.</p>
      </section>

      <section class="contract-section" id="background">
        <h2 class="registration-title">Background Checks</h2>
        <p>Background Checks are reports of your work and legal history. In the United States all mentors are required to complete and pass a background check in order to be allowed and verified on our site. <br> <br> In other countries and territories, we will randomly select mentors to provide references and legal certifications, and to submit to background checks where possible. If you are selected, we will contact you to complete the process. You must consent to this to be allowed and verified on our site. <br> <br> Thank you for helping us keep our students safe.</p>
      </section>

      <hr class="contract-hr mb-8">

      <section class="contract-section" id="agree-checkbox">
        <FormulateInput
            type="checkbox"
            label="I AGREE TO THESE DATA USE TERMS"
            name="contractLabel"
        />
      </section>
    </div>
  </div>
</template>

<script>
import ContainerHeader from "./ContainerHeader";
export default {
  name: "StepThree",
  components: {
    ContainerHeader
  },
  props: ['formValues']
}
</script>

<style scoped>
  .contract-section{
    @apply mb-8
  }

  .contract-hr{
    border-width: 1px;
    border-color: #0075cf;
    background-color: #0075cf;
  }

  a{
    color: #0075cf;
    font-weight: bold;
  }
</style>