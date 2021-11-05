<template>
  <div id="contact-us" class="max-w-6xl mx-auto text-left">
    <section id="info">
      <h2 class="registration-title rubik font-black text-4xl"> CONTACT US</h2>
      <p>To learn more about our programs and research, howe we work with partners, or to create a partnership tailored to fit your organization's needs.</p>
    </section>

    <section id="links" class="flex flex-wrap-reverse md:flex-nowrap justify-between my-12">
      <div id="icons" class="flex mx-auto md:mx-0 my-8 md: my-0 w-1/2 md:w-48 justify-between">
        <img :src="require('social-media/fb.png')" alt="" class="social-icon">
        <img :src="require('social-media/twitter.png')" alt="" class="social-icon">
        <img :src="require('social-media/instagram.png')" alt="" class="social-icon">
        <img :src="require('social-media/youtube.png')" alt="" class="social-icon">
      </div>

      <div id="site-links" class="flex flex-wrap w-full  md:mx-0 md:w-1/2 my-8 md: my-0">
        <a href="#" class="site-link">FAQ</a>
        <a href="#" class="site-link">Contact</a>
        <a href="#" class="site-link">Terms of Use</a>
        <a href="#" class="site-link">Press</a>
        <a href="#" class="site-link">Privacy Policy</a>
        <a href="#" class="site-link">Donate</a>
      </div>
    </section>
  </div>
</template>

<script>
export default {
  name: 'ContactUs'
}
</script>

<style scoped>
.social-icon{
  width: 40px;
  height: 40px;
}

.site-link{
  margin: 5px;
  width: calc(100% * (1/4) - 10px - 1px);
}
</style>
