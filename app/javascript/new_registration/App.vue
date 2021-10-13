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

.registration-btns{
  @apply px-4 py-2 rounded bg-green-500 text-white hover:bg-green-600
}

.registration-nav{
  @apply py-4 px-2 hover:text-blue-500 transition duration-300;
}

.registration-nav-mobile{
  @apply block text-sm px-2 py-4 hover:bg-blue-500 hover:text-white transition duration-300;
}

.registration-container{
  @apply container mx-auto max-w-2xl border-4 border-energetic-blue rounded-md;
}

.registration-title{
  @apply text-2xl mb-2 text-left font-semibold;
}

#step-two input, #step-four input{
  @apply border border-gray-400 rounded px-3 py-2 leading-none focus:border-green-500 outline-none w-full mb-1
}

.name-group {
  @apply flex justify-between;
}

.tg-green-stripes{
  background: repeating-linear-gradient(
      45deg,
      #5FBC4A,
      #5FBC4A 10px,
      #43b02a 10px,
      #43b02a 26px
  );
}

.rubik{
  font-family: 'RUBIK', sans-serif;
}

.form-wrapper{
  @apply p-6
}
</style>