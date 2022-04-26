<template>
  <div>
    <EnergeticContainer heading="Review Score">
      <TeamInfo/>
      <ThickRule/>
      <div class="w-full lg:w-1/2 mx-auto">
        <div v-for="detail in sectionDetails" class="odd:bg-gray-200 p-6">
          <router-link
          :to="{ name: detail.section }"
          v-tooltip.top-center="`Make changes to your ${detail.displayName} score`"
          :key="detail.section"
        >
          <div>
            <p class="flex">
              <icon
                v-if="problemInSection(detail.section)"
                :alt="`Problem indicated in ${detail.section}`"
                :title="`Problem indicated in ${detail.section}`"
                name="exclamation-triangle"
                color="d0006f"
                size="18"
                class-name="mr-4"
              />
              <span class="font-bold">{{ detail.displayName | capitalize }}</span>
            </p>
          </div>
          <div class="font-bold text-4xl text-center">
            {{ sectionPointsTotal(detail.section) }}
          </div>
        </router-link>
        </div>

        <div class="p-6">
          <p class="font-bold">Final Total Score</p>
          <p class="text-center font-bold text-4xl">{{ totalScore }}</p>
        </div>

        <p class="mt-8 text-center" v-tooltip.top-center="finishScoreTooltip">
          <a
            :href="`/judge/score_completions?id=${score.id}`"
            :disabled="isScoreIncomplete"
            :class="isScoreIncomplete ? 'opacity-50 cursor-not-allowed' : ''"
            class="tw-green-btn"
            data-method="post"
          >
            Submit score
          </a>
        </p>
      </div>
    </EnergeticContainer>
  </div>
</template>

<script>
import { mapState, mapGetters, mapActions } from 'vuex'

import Icon from '../../../components/Icon'
import EnergeticContainer from "../../components/EnergeticContainer";
import TeamInfo from "../TeamInfo";
import ThickRule from "../../components/ThickRule";

export default {
  components: {
    Icon,
    EnergeticContainer,
    TeamInfo,
    ThickRule
  },

  created () {
    this.validateScore()
  },

  methods: {
    ...mapActions(['validateScore']),
  },

  computed: {
    ...mapState(['team', 'score', 'submission', 'deadline']),

    ...mapGetters([
      'anyCommentsInvalid',
      'anyScoresEmpty',
      'sectionPointsTotal',
      'totalScore',
      'problemInSection'
    ]),

    sectionDetails () {
      let sectionDetails = [
        { section: 'project_details', displayName: 'Project Name & Description' },
        { section: 'ideation', displayName: 'Learning Journey' },
        { section: 'pitch', displayName: 'Pitch' },
        { section: 'demo', displayName: 'Demo' },
      ]

      if(this.team.division === 'senior'){
        sectionDetails.push(
          {
            section: 'entrepreneurship',
            displayName: 'Business Plan'
          }
        )
      } else if (this.team.division === 'junior'){
        sectionDetails.push(
          {
            section: 'entrepreneurship',
            displayName: 'User Adoption Plan'
          }
        )
      }
      return sectionDetails
    },

    isScoreIncomplete () {
      // Check remote database instead of local state
      // GET `/judge/scores/${this.score.id}.json`
      // Modify JSON returned in app/serializers/score_serializer.rb
      return this.anyCommentsInvalid || this.anyScoresEmpty
    },

    finishScoreTooltip () {
      if (this.isScoreIncomplete) {
        return 'Your score is not ready to be finished. ' +
               'Enter a score for each question, and a ' +
               'friendly, sufficient comment for each section'
      } else {
        return 'You can revisit your finished scores ' +
               'and make changes through ' + this.deadline + '.'
      }
    },
  },

  watch: {
    '$route': 'validateScore',
  },
}
</script>