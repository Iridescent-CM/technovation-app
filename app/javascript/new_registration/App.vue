<template>
  <div class="home" id="home">
    <Navbar/>
    <Banner/>
    <FormWrapper/>
    <div id="thick-rule" class="bg-energetic-blue h-6 my-16"></div>
    <ContactUs/>
    <Footer/>
  </div>
</template>

<script>
import Navbar from "./components/Navbar";
import Banner from "./components/Banner";
import Footer from "./components/Footer";
import ContactUs from "./components/ContactUs";
import FormWrapper from "./components/FormWrapper";


export default {
  name: 'app',
  components: {
    Navbar,
    Banner,
    Footer,
    ContactUs,
    FormWrapper
  }
}
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