<template>
  <div
    class="
      grid
      grid--bleed
      grid--align-start
      grid--justify-space-between
    "
  >
    <div class="grid__col-auto">
      <h3>{{ title }}</h3>

      <p class="refer-to">Refer to the {{ referTo }}</p>

      <score-entry :questions="questions">
        <slot />
      </score-entry>
    </div>

    <div class="grid__col-6">
      <h3>{{ sectionTitle}} comment</h3>

      <h5 class="heading--reset">Please keep in mind</h5>

      <slot name="comment-tips" />

      <textarea v-model="comment" />

      <div class="comment-sentiment">
        <div
          v-tooltip.top-center="sentimentTooltip('positive')"
          :style="`width: ${sentimentPercentage('positive')}`"
        ></div>

        <div
          v-tooltip.top-center="sentimentTooltip('neutral')"
          :style="`width: ${sentimentPercentage('neutral')}`"
        ></div>

        <div
           v-tooltip.top-center="sentimentTooltip('negative')"
          :style="`width: ${sentimentPercentage('negative')}`"
        ></div>
      </div>

      <div class="grid grid--bleed grid--justify-space-between">
        <div class="grid__col-6">
          <p><small>(please write at least 40 words)</small></p>
        </div>

        <div class="grid__col-6">
          <p class="word-count">
            <span :style="`color: ${colorForWordCount}`">
              {{ wordCount(comment) }}
              {{ wordCount(comment) | pluralize('word') }}
            </span>

            <br />

            <span :style="`color: ${colorForBadWordCount}`">
              {{ badWordCount }}
              {{ badWordCount | pluralize('prohibited word') }}
            </span>
          </p>
        </div>

        <div class="grid__col-6 nav-btns--left">
          <p>
            <router-link
              v-if="!!prevSection"
              :to="{ name: prevSection }"
              class="button button--small btn-prev"
            >
              Back: {{ prevBtnTxt }}
            </router-link>
          </p>
        </div>

        <div class="grid__col-6 nav-btns--right">
          <p>
            <span v-tooltip="nextDisabledMsg">
              <router-link
                v-if="!!nextSection"
                :to="{ name: nextSection }"
                :disabled="goingNextIsDisabled"
                class="button button--small btn-next"
              >
                Next: {{ nextBtnTxt }}
              </router-link>
            </span>
          </p>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import _ from 'lodash'
import { mapState } from 'vuex'

import ScoreEntry from './ScoreEntry'

export default {
  name: 'QuestionSection',

  data () {
    return {
      comment: '',

      sentiment: {
        negative: 0,
        positive: 0,
      },

      detectedProfanity: {},
    }
  },

  watch: {
    comment (current, old) {
      this.handleCommentChange(current, old)
    },

    //
    // FIXME hacky watcher to fill comment after
    // remote score data is loaded
    //
    submissionId () {
      const comment = window.localStorage.getItem(
        this.commentStorageKey
      )

      if (!!comment) {
        this.comment = comment
      } else {
        this.comment = this.$store.getters.comment(this.section)
      }

      if (!this.comment) {
        this.comment = ''
      }
    },
  },

  computed: {
    ...mapState(['submission']),

    nextDisabledMsg () {
      if (this.goingNextIsDisabled) {
        return "Please write a substantial comment, keep it clean, and be friendly"
      } else {
        return false
      }
    },

    goingNextIsDisabled () {
      return this.wordCount(this.comment) < 40 ||
               this.badWordCount > 0 ||
                 this.sentiment.negative > 0.4
    },

    badWordCount () {
      return _.reduce(this.detectedProfanity, (acc, value, key) => {
        return acc += value
      }, 0)
    },

    colorForWordCount () {
      const count = this.wordCount(this.comment)

      if (count >= 40) {
        return 'darkgreen'
      } else if (count >= 30) {
        return 'orange'
      } else if (count >= 20) {
        return 'darkyellow'
      } else {
        return 'darkred'
      }
    },

    colorForBadWordCount () {
      const count = this.badWordCount

      if (count < 1) {
        return 'darkgreen'
      } else {
        return 'darkred'
      }
    },

    sectionTitle () {
      return _.capitalize(this.section)
    },

    questions () {
      return this.$store.getters.sectionQuestions(this.section)
    },

    commentStorageKey () {
      return `${this.section}-comment-${this.submission.id}`
    },

    nextBtnTxt () {
      return this.nextSectionTitle || _.capitalize(this.nextSection)
    },

    prevBtnTxt () {
      return _.capitalize(this.prevSection)
    },
  },

  props: [
    'title',
    'referTo',
    'nextSection',
    'prevSection',
    'section',
    'nextSectionTitle',
  ],

  components: {
    ScoreEntry,
  },

  methods: {
    sentimentTooltip (slant) {
      return 'Your comment seems ' +
             this.sentimentPercentage(slant) + ' ' +
             slant
    },

    sentimentPercentage (slant) {
      return `${Math.round(this.sentiment[slant] * 100)}%`
    },

    handleCommentChange: _.debounce(function(current_val, old_val) {
      if (!!current_val && current_val !== old_val) {
        window.localStorage.setItem(this.commentStorageKey, current_val)

        this.$store.commit('setComment', {
          sectionName: this.section,
          text: current_val,
        })

        Algorithmia.client("sim7BOgNHD5RnLXe/ql+KUc0O0r1")
          .algo("nlp/SocialSentimentAnalysis/0.1.4")
          .pipe({ sentence: current_val })
          .then(resp => { this.sentiment = resp.result[0] });

        Algorithmia.client("sim7BOgNHD5RnLXe/ql+KUc0O0r1")
          .algo("nlp/ProfanityDetection/1.0.0")
          .pipe([current_val, [], false])
          .then(resp => { this.detectedProfanity = resp.result });
      }
    }, 1000),

    wordCount (comment) {
      return _.filter(comment.split(' '), w => {
        return _.filter(w.split(''), c => { return c.match(/\w/) }).length > 2
      }).length
    },
  },

  mounted () {
    const comment = window.localStorage.getItem(this.commentStorageKey)
    if (!!comment) this.comment = comment
  },
}
</script>

<style lang="scss" scoped>
  .refer-to {
    font-size: 0.9rem;
    font-style: italic;
    margin: 0;
  }

  textarea {
    border: 0;
    width: 100%;
    height: 40vh;
    margin: 1rem 0 0;
    padding: 1rem;
    box-shadow: inset 0.2rem 0.2rem 0.2rem rgba(0, 0, 0, 0.2);
  }

  .nav-btns--right {
    text-align: right;
  }

  .word-count {
    text-align: right;
    font-size: 1rem;
    font-weight: bold;
    margin: 0.5rem 0;
  }

  .word-count__note {
    font-weight: normal;
  }

  .comment-sentiment {
    display: flex;

    color: white;
    font-weight: bold;
    font-size: 0.9rem;

    div {
      transition: width 1s ease-in-out;
      overflow: hidden;
      background: IndianRed;
      padding: 0.5rem 0;

      &:first-child {
        background: MediumSeaGreen;
      }

      &:nth-child(2) {
        background: SteelBlue;
      }
    }
  }
</style>
