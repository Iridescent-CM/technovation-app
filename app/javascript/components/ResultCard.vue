<template>
  <div class="card-result max-w-sm rounded-lg overflow-hidden shadow-lg grid__col--bleed">
    <img :src="cardImage" class="w-full" @error="imgBroken" />

    <div class="card-photo-placeholder" :id="imgPlaceholderId">
      <p class="text-xl font-bold text-black-200">No picture<p/>
    </div>
    
    <div class="px-6 py-4">
      <div class="search-card-title font-bold text-xl mb-1">{{ cardTitle }}</div>
      <div class="search-card-subtitle py-1 text-base">{{ cardSubtitle }}</div>
      <div class="search-card-content py-1 text-base mb-2">{{ cardContent }}</div>

      <div v-if="declined" class="search-card-footer text-right mt-6">
          <p class="text-base text-red-500">You asked to join {{ name }}, and they declined.</p>
      </div>
      <div v-else-if="full" class="search-card-footer text-right mt-6">
        <p class="text-base text-red-500">This team is currently full.</p>
      </div>
      <div v-else class="search-card-footer text-right mt-6">
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
        e.target.style = 'display:none';
        e.target.nextElementSibling.style = 'display:flex';
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
  .card-photo-placeholder {
    display: none;
    background-color: #aeaeae;
    width: 100%;
    align-items: center;
    justify-content: center;
    padding-top:33.5%;
    padding-bottom:33.5%;
  }
</style>