<template>
  <div class="flex">
    <span v-for="question in questionsForSection(section)">
      <svg
        :class="question.score > 0 ? 'text-tg-green' : 'text-gray-300'"
        class="h-5 w-5"
        xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor"
      >
        <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd" />
      </svg>
    </span>

    <svg
      :class="commentForSection(section).word_count >= 20 ? 'text-tg-green': 'text-gray-300'"
      class="h-5 w-5"
      xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor"
    >
      <path fill-rule="evenodd" d="M18 5v8a2 2 0 01-2 2h-5l-5 4v-4H4a2 2 0 01-2-2V5a2 2 0 012-2h12a2 2 0 012 2zM7 8H5v2h2V8zm2 0h2v2H9V8zm6 0h-2v2h2V8z" clip-rule="evenodd" />
    </svg>
  </div>
</template>

<script>
export default {
  props: {
    section: {
      type: String,
      required: true
    },
  },

  methods: {
    questionsForSection(section) {
      return this.$store.getters.sectionQuestions(section)
    },

    commentForSection(section) {
      return this.$store.getters.comment(section)
    }
  }
}
</script>
