<template>
  <div id="home" class="home">
    <RegistrationNavbar />
    <RegistrationBanner />
    <FormWrapper />
    <div id="thick-rule" class="bg-energetic-blue h-6 my-16"></div>
    <ContactUs />
    <RegistrationFooter />
  </div>
</template>

<script>
import RegistrationNavbar from "./components/RegistrationNavbar";
import RegistrationBanner from "./components/RegistrationBanner";
import RegistrationFooter from "./components/RegistrationFooter";
import ContactUs from "./components/ContactUs";
import FormWrapper from "./components/FormWrapper";

export default {
  name: "App",
  components: {
    RegistrationNavbar,
    RegistrationBanner,
    RegistrationFooter,
    ContactUs,
    FormWrapper,
  },
};
</script>

<style>
#home {
  font-family: Poppins, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
}
</style>
