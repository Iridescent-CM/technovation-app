<template>
  <div>
    <EnergeticContainer heading="Review Score">
    <TeamInfo/>
    <ThickRule/>

    <ul role="list" class="divide-y divide-gray-200">
      <li v-for="section in sections" class="py-4">
        <router-link
          :to="{ name: section.name }"
          :key="section.name"
        >
          <div class="flex space-x-3">
            <div
              v-if="!isSectionComplete(section.name)"
              :alt="`Problem indicated in ${section.title}`"
              :title="`Problem indicated in ${section.title}`"
              class="text-red-400"
            >
              <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8" viewBox="0 0 20 20" fill="currentColor">
                <path fill-rule="evenodd" d="M8.257 3.099c.765-1.36 2.722-1.36 3.486 0l5.58 9.92c.75 1.334-.213 2.98-1.742 2.98H4.42c-1.53 0-2.493-1.646-1.743-2.98l5.58-9.92zM11 13a1 1 0 11-2 0 1 1 0 012 0zm-1-8a1 1 0 00-1 1v3a1 1 0 002 0V6a1 1 0 00-1-1z" clip-rule="evenodd" />
              </svg>
            </div>

            <div v-else class="text-tg-green">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8" viewBox="0 0 20 20" fill="currentColor">
                <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd" />
              </svg>
            </div>

            <div class="flex-1">
              <div class="flex items-center justify-between">
                <h3 class="text-lg text-gray-700">
                  {{ section.title }}
                </h3>

                <p class="self-end text-xl text-gray-700 font-semibold">
                  {{ section.pointsTotal }}
                </p>
              </div>

              <div class="flex">
                <span v-for="question in questionsForSection(section.name)">
                  <svg
                    :class="question.score > 0 ? 'text-tg-green' : 'text-gray-300'"
                    class="h-5 w-5"
                    xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor"
                  >
                   <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd" />
                  </svg>
                </span>

                <svg
                  :class="commentForSection(section.name).word_count >= 20 ? 'text-tg-green': 'text-gray-300'"
                  class="h-5 w-5"
                  xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor"
                >
                 <path fill-rule="evenodd" d="M18 5v8a2 2 0 01-2 2h-5l-5 4v-4H4a2 2 0 01-2-2V5a2 2 0 012-2h12a2 2 0 012 2zM7 8H5v2h2V8zm2 0h2v2H9V8zm6 0h-2v2h2V8z" clip-rule="evenodd" />
                </svg>
              </div>
            </div>
          </div>
        </router-link>
      </li>
    </ul>

    <div class="w-full border-t border-gray-800"></div>

    <ul role="list">
      <li class="py-2">
        <div class="flex space-x-3">
          <div class="flex-1 space-y-1">
            <div class="flex items-center justify-between">
              <h3 class="text-2xl text-gray-900 font-bold">Total Score</h3>
              <p class="self-end text-2xl text-gray-900 font-bold">
                {{ totalScore }}
              </p>
            </div>
          </div>
        </div>
      </li>
    </ul>

    <p class="mt-12 text-center" v-tooltip.top-center="finishScoreTooltip">
      <a
        :href="`/judge/score_completions?id=${score.id}`"
        :disabled="isScoreIncomplete"
        :class="isScoreIncomplete ? 'opacity-50 cursor-not-allowed pointer-events-none' : ''"
        class="link-button md-link-button link-button-success"
        data-method="post"
      >
        {{ isScoreComplete ? "Update Score" : "Finish Score" }}
      </a>
    </p>
    </EnergeticContainer>
  </div>
</template>

<script>
import { mapState, mapGetters, mapActions } from 'vuex'

import EnergeticContainer from "../../components/EnergeticContainer";
import TeamInfo from "../TeamInfo";
import ThickRule from "../../components/ThickRule";

export default {
  components: {
    EnergeticContainer,
    TeamInfo,
    ThickRule
  },


  methods: {
    questionsForSection(section) {
      return this.$store.getters.sectionQuestions(section)
    },

    commentForSection(section) {
      return this.$store.getters.comment(section)
    }
  },

  computed: {
    ...mapState(['team', 'score', 'submission', 'deadline']),

    ...mapGetters([
      'hasIncompleteSections',
      'totalScore',
      'isSectionComplete'
    ]),

    sections () {
      return this.$store.getters.sections
    },

    isScoreIncomplete () {
      return this.hasIncompleteSections
    },

    isScoreComplete () {
      return this.$store.getters.isScoreComplete
    },

    finishScoreTooltip () {
      if (this.isScoreIncomplete) {
        return 'Please enter a score for each question and a comment for each section.'
      } else {
        return 'You can revisit your finished scores ' +
          'and make changes through ' + this.deadline + '.'
      }
    },
  },
}
</script>
