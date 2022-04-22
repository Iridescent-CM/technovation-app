<template>
  <div class="grid">
    <div class="grid__col-12 grid__col--bleed-y">
      <h2>Review score</h2>
    </div>

    <team-info />

    <div class="grid__col-9 grid__col--bleed-y">
      <h1 class="border--b-thin-primary">{{ submission.name }}</h1>

      <div class="app-description" v-html="submission.description"></div>

      <div class="grid grid--justify-space-around">
        <div class="grid__col-9 panel">
          <h1>Review your score</h1>

          <router-link
            :to="{ name: name }"
            v-tooltip.top-center="`Make changes to your ${name} score`"
            v-for="name in sectionNames"
            :key="name"
            class="grid grid--bleed row"
          >
            <div class="grid__col-11">
              <p>
                <icon
                  v-if="problemInSection(name)"
                  :alt="`Problem indicated in ${name}`"
                  :title="`Problem indicated in ${name}`"
                  name="exclamation-triangle"
                  color="903D54"
                  size="18"
                />
                {{ name | capitalize }}
              </p>
            </div>

            <div class="grid__col-1">
              {{ sectionPointsTotal(name) }}
            </div>
          </router-link>

          <div class="grid grid--bleed row row--bottom">
            <div class="grid__col-11">
              Final total score
            </div>

            <div class="grid__col-1">
              {{ totalScore }}
            </div>
          </div>
        </div>
      </div>

      <div class="grid grid--bleed grid--justify-space-around">
        <div class="grid__col-auto">
          <p
            class="align-center"
            v-tooltip.top-center="finishScoreTooltip"
          >
            <a
              :href="`/judge/score_completions?id=${score.id}`"
              :disabled="isScoreIncomplete"
              class="button"
              data-method="post"
            >
              Finish score
            </a>
          </p>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { mapState, mapGetters, mapActions } from 'vuex'

import Icon from '../../../components/Icon'

import TeamInfo from '../TeamInfo'

export default {
  components: {
    Icon,
    TeamInfo,
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

    sectionNames () {
      let names = [
        'overview',
        'ideation',
        'pitch',
        'demo',
      ]

      if (this.team.division === 'senior' || this.team.division == 'junior')
        names.push('entrepreneurship')

      return names
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

<style lang="scss" scoped>
  .panel {
    padding: 0;

    h1 {
      margin: 1rem 0;
    }
  }

  .row {
    color: black;
    padding: 0.5rem 1rem;

    &:nth-child(even) {
      background: DarkSeaGreen;
    }

    &:not(.row--bottom) {
      opacity: 0.8;
      transition: opacity 0.2s;

      &:hover {
        opacity: 1;
      }
    }

    div {
      display: flex;
      justify-content: center;
      flex-direction: column;
      position: relative;

      img {
        position: absolute;
        top: 0.65rem;
        left: -50px;
      }

      &.grid__col-1 {
        font-size: 2rem;
        color: #666;
        font-weight: bold;
        text-align: center;
      }
    }
  }

  .align-center {
    text-align: center;
  }
</style>
