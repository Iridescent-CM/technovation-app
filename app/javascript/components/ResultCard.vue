<template>
  <div class="card-result">
    <img :src="cardImage" class="w-full" @error="imgBroken" />

    <div class="card-photo-placeholder hidden" :id="imgPlaceholderId">
      <p class="text-xl font-bold text-black-200">No picture<p/>
    </div>
    
    <div class="body px-6 py-4">
      <div class="search-card-title font-bold text-xl mb-1">{{ cardTitle }}</div>
      <div class="search-card-subtitle py-1 text-base">{{ cardSubtitle }}</div>
      <div class="search-card-content py-1 text-base mb-2">{{ cardContent }}</div>

      <div v-if="declined" class="search-card-footer">
          <p>You asked to join {{ name }}, and they declined.</p>
      </div>
      <div v-else-if="full" class="search-card-footer">
        <p>This team is currently full.</p>
      </div>
      <div v-else class="search-card-footer">
        <a :href="linkPath" class="tw-link text-lg" >{{ linkText }}</a>
      </div>
    </div>
  </div>
</template>

<script>
  export default {
    name: 'result-card',
    methods: {
      imgBroken(e) {
        e.target.classList.add("hidden")
        e.target.nextElementSibling.classList.remove("hidden")
        e.target.nextElementSibling.classList.add("flex")
      }
    },
    props: {
      cardId: {
        type: String,
        required: true,
      },
      cardImage: {
        type: String,
        required: false,
      },
      cardTitle: {
        type: String,
        required: false,
      },
      cardSubtitle: {
        type: String,
        required: false,
      },
      cardContent: {
        type: String,
        required: false,
      },
      name: {
        type: String,
        required: false,
      },
      declined: {
        type: Boolean,
        required: false,
      },
      full: {
        type: Boolean,
        required: false,
      },
      linkText: {
        type: String,
        required: false,
      },
      linkPath: {
        type: String,
        required: false,
      },
    },
    computed: {
      imgPlaceholderId() {
        return `img-ph-${this.cardId}`;
      }
    }
  }
</script>

<style lang="scss">
  .card-result {
    @apply max-w-sm rounded-lg overflow-hidden shadow-lg mb-5
  }
  .card-photo-placeholder {
    @apply bg-slate-300 w-full items-center justify-center pt-[33.5%] pb-[33.5%]
  }
  .search-card-footer {
    @apply text-right mt-6
  }
  .search-card-footer p {
    @apply text-base text-red-500
  }
</style>