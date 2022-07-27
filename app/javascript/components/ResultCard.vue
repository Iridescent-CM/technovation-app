<template>
  <div class="card-result">
    <div class="relative">
      <img :src="cardImage" :class="coverImageClass(coverImage)" @error="imgBroken" />

      <div class="card-photo-placeholder hidden" :id="imgPlaceholderId">
        <p class="text-xl font-bold text-black-200">No picture<p/>
      </div>

      <div v-if="showBadges" class="flex flex-col items-end absolute bottom-1 right-0">
        <span :class="badge('team', isOnTeam)">{{ onTeamText }}</span>
        <span :class="badge('virtual', isVirtual)">{{ virtualText }}</span>
      </div>
    </div>

    <div class="body px-6 py-4">
      <div class="card-title">{{ cardTitle }}</div>
      <div class="card-text">{{ cardSubtitle }}</div>
      <div class="card-text">{{ cardContent }}</div>

      <div v-if="declined" class="search-card-footer">
          <p>You asked to join {{ name }}, and they declined.</p>
      </div>
      <div v-else-if="full" class="search-card-footer">
        <p>This team is currently full.</p>
      </div>
      <div v-else class="search-card-footer">
        <a :href="linkPath" class="tw-link text-base md:text-base lg:text-base" >{{ linkText }}</a>
      </div>
    </div>
  </div>
</template>

<script>
  export default {
    name: 'result-card',
    props: {
      cardId:       { type: String,  required: true },
      cardImage:    { type: String,  required: false },
      cardTitle:    { type: String,  required: false },
      cardSubtitle: { type: String,  required: false },
      cardContent:  { type: String,  required: false },
      name:         { type: String,  required: false },
      linkText:     { type: String,  required: false },
      linkPath:     { type: String,  required: false },
      onTeamText:   { type: String,  required: false },
      virtualText:  { type: String,  required: false },
      coverImage:   { type: Boolean, required: false },
      declined:     { type: Boolean, required: false },
      full:         { type: Boolean, required: false },
      showBadges:   { type: Boolean, required: false },
      isOnTeam:     { type: Boolean, required: false },
      isVirtual:    { type: Boolean, required: false },
    },
    methods: {
      imgBroken(e) {
        e.target.classList.add("hidden")
        e.target.nextElementSibling.classList.remove("hidden")
        e.target.nextElementSibling.classList.add("flex")
      },
      badge(type, flag) {
        let bgs = {
          'team': { on: 'bg-blue-600', off:'bg-pink-600' },
          'virtual': { on: 'bg-pink-600', off:'bg-blue-600' }
        }
        
        let bg = flag ? bgs[type].on : bgs[type].off
        
        return `list-badge ${bg} left-arrow uppercase`
      },
      coverImageClass(flag) {
        return flag ? 'w-full' : 'object-contain h-48 w-96'
      }
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
    @apply max-w-sm rounded-lg overflow-hidden shadow-lg m-auto h-96 w-60
  }
  .card-title {
    @apply font-bold text-base mb-1
  }
  .card-text {
    @apply text-base whitespace-nowrap overflow-ellipsis overflow-hidden
  }
  .card-photo-placeholder {
    @apply bg-gray-300 w-full items-center justify-center object-contain h-48 w-96
  }
  .search-card-footer {
    @apply text-right mt-6
  }
  .search-card-footer p {
    @apply text-base text-red-500
  }
  .list-badge {
    @apply text-xs py-3 px-3 mb-1 leading-none text-center align-baseline font-bold text-white
  }
  .left-arrow {
    clip-path: polygon(15% 0%, 100% 1%, 100% 100%, 15% 100%, 0% 50%);
  }
</style>