<template>
  <li class="pb-6">
    <router-link
      :to="{ name: this.sectionName }"
      class="hover:text-tg-dark-green"
    >
      <div
        :class="this.isActive ? 'text-tg-green' : ''"
        class="flex items-center group truncate hover:text-tg-green"
      >
        <span class="flex items-center" aria-hidden="true">
          <span v-if="this.isActive"
            class="w-6 h-6 flex items-center justify-center bg-white border-2 border-tg-green rounded-full"
          >
            <span class="h-2.5 w-2.5 bg-tg-green rounded-full"></span>
          </span>

          <span v-else-if="this.isComplete"
            class="w-6 h-6 flex items-center justify-center bg-tg-green rounded-full group-hover:bg-tg-dark-green"
          >
            <svg class="w-5 h-5 text-white" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
              <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd" />
            </svg>
          </span>

          <span v-else
            class="w-6 h-6 flex items-center justify-center bg-white border-2 border-gray-300 rounded-full"
          >
          </span>
        </span>

        <div class="ml-3 min-w-0">
          <h5
            :class="this.isActive ? 'font-medium' : 'font-normal'"
            class="text-base tracking-wide"
          >
            {{ this.sectionTitle }}
          </h5>
        </div>
      </div>

      <div class="flex justify-between">
        <div v-if="showSectionProgress" class="ml-8">
          <SectionProgressIcons :section="sectionName" />
        </div>

        <p
          :class="this.isActive ? 'font-semibold text-gray-600' : 'font-normal text-gray-500'"
          class="ml-auto text-sm text-right">
          {{ this.sectionScore || "&nbsp;" }}
        </p>
      </div>
    </router-link>
  </li>
</template>

<script>
import SectionProgressIcons from './pieces/SectionProgressIcons'

export default {
  props: {
    sectionName: {
      type: String,
      required: true
    },
    sectionTitle: {
      type: String,
      required: true
    },
    sectionScore: {
      type: String,
      required: false
    },
    showSectionProgress: {
      type: Boolean,
      default: false
    },
    isActive: {
      type: Boolean,
      default: false
    },
    isComplete: {
      type: Boolean,
      default: false
    },
  },

  components: {
    SectionProgressIcons
  }
}
</script>
