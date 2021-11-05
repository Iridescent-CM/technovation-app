<template>
  <nav class="bg-white">
    <div class="max-w-7xl mx-auto px-1">
      <div class="flex justify-between">
          <div>
            <a href="#" class="flex items-center py-4 px-2">
              <img id="tg-logo" :src="require('tg-girls-logo.png')" alt="Technovation Girls Logo" />
            </a>
          </div>
        <div class="flex space-x-7">
          <div class="md:flex items-center space-x-1">
            <a href="" class="registration-nav">Get Started</a>
            <a href="" class="registration-nav">Chapters</a>
            <a href="" class="registration-nav">About</a>
            <a href="" class="registration-nav">Login</a>
            <a href="" class="registration-nav">Sign Up</a>
            <a href="" class="py-2 px-2 text-white font-black rounded transition duration-300 bg-energetic-blue">DONATE</a>
          </div>
        </div>

        <div class="md:hidden flex items-center">
          <button class="outline-none mobile-menu-button">
            <svg class=" w-6 h-6 text-gray-500 hover:text-green-500 "
                 x-show="!showMenu"
                 fill="none"
                 stroke-linecap="round"
                 stroke-linejoin="round"
                 stroke-width="2"
                 viewBox="0 0 24 24"
                 stroke="currentColor"
            >
              <path d="M4 6h16M4 12h16M4 18h16"></path>
            </svg>
          </button>
        </div>
      </div>
    </div>

    <div class="hidden mobile-menu">
      <ul class="">
        <li><a href="" class="registration-nav-mobile">Get Started</a></li>
        <li><a href="" class="registration-nav-mobile">Chapters</a></li>
        <li><a href="" class="registration-nav-mobile">About</a></li>
        <li><a href="" class="registration-nav-mobile">Login</a></li>
        <li><a href="" class="registration-nav-mobile">Signup</a></li>
        <li><a href="" class="registration-nav-mobile">DONATE</a></li>
      </ul>
    </div>
  </nav>

</template>

<script>
export default {
  name: "Navbar",
  // mounted() {
  //   const btn = document.querySelector("button.mobile-menu-button");
  //   const menu = document.querySelector(".mobile-menu");
  //
  //   // Add Event Listeners
  //   btn.addEventListener("click", () => {
  //     menu.classList.toggle("hidden");
  //   });
  // }
};
</script>

<style scoped>
nav {
  font-family: 'Poppins', sans-serif;
}

 #tg-logo{
   width: 13rem;
 }
</style>
