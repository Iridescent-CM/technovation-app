<template>
  <div class="grid grid--align-start grid--justify-space-between ">
    <div :class="solo ? 'grid__col-md-6' : 'grid__col-12'">
      <h3>{{ title }}</h3>

      <p class="refer-to">Refer to the {{ referTo }}</p>

      <score-entry :questions="questions">
        <slot />
      </score-entry>
    </div>

    <div :class="solo ? 'grid__col-md-6' : 'grid__col-12 col--sticky-parent'">
      <div class="col--sticky-spacer">
        <div class="col--sticky">
          <h3>{{ section | capitalize }} comment</h3>

          <h5 class="heading--reset">Please keep in mind</h5>

          <slot name="comment-tips" />

          <div class="grid grid--bleed grid--justify-space-between">
            <div class="grid__col-6 grid--align-self-end">
              <small>(please write at least 40 words, and be less than 40% negative)</small>
            </div>

            <div class="grid__col-6">
              <p class="word-count">
                <span :style="`color: ${colorForWordCount}`">
                  {{ wordCount(comment.text) }}
                  {{ wordCount(comment.text) | pluralize('word') }}
                </span>

                <br />

                <span :style="`font-size: ${fontSizeForBadWordCount}; color: ${colorForBadWordCount}`">
                  {{ badWordCount }}
                  {{ badWordCount | pluralize('prohibited word') }}
                </span>
              </p>
            </div>
          </div>

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

          <textarea v-model="comment.text" />

          <div class="grid grid--bleed grid--justify-space-between">
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
      counter: 0,

      comment: {
        text: '',
        sentiment: {
          negative: 0,
          positive: 0,
          neutral: 0,
        },
        bad_word_count: 0,
        word_count: 0,
      },

      detectedProfanity: {},

      commentInitiated: false,
    }
  },

  watch: {
    commentText () {
      if (this.commentInitiated)
        this.handleCommentChange()
    },

    commentStorageKey () {
      this.initiateComment()
    },
  },

  computed: {
    ...mapState(['submission']),

    commentText () {
      return this.comment.text
    },

    nextDisabledMsg () {
      if (this.goingNextIsDisabled) {
        return 'Please write a substantial comment, ' +
               'keep it clean, and be friendly'
      } else {
        return false
      }
    },

    goingNextIsDisabled () {
      return this.wordCount(this.comment.text) < 40 ||
               this.badWordCount > 0 ||
                 this.comment.sentiment.negative > 0.4
    },

    badWordCount () {
      return _.reduce(this.detectedProfanity, (acc, value, key) => {
        return acc += value
      }, 0)
    },

    colorForWordCount () {
      const count = this.wordCount(this.comment.text)

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

    fontSizeForBadWordCount () {
      const count = this.badWordCount

      if (count < 1) {
        return 'inherit'
      } else {
        return '1.3rem'
      }
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
    'solo',
  ],

  components: {
    ScoreEntry,
  },

  methods: {
    initiateComment () {
      const storeComment = this.$store.getters.comment(this.section)

      if (!!storeComment)
        this.comment = storeComment

      const text = window.localStorage.getItem(this.commentStorageKey)
      if (!!text) this.comment.text = text

      if (!this.comment.text)
        this.comment.text = ''

      this.$nextTick().then(() => {
        this.commentInitiated = true
      })
    },

    wordCount (text) {
      return _.filter(text.split(' '), word => {

        return _.filter(word.split(''), char => {
          return char.match(/\w/)
        }).length > 2

      }).length
    },

    sentimentTooltip (slant) {
      return 'Your comment seems ' +
             this.sentimentPercentage(slant) + ' ' +
             slant
    },

    sentimentPercentage (slant) {
      return `${Math.round(parseFloat(this.comment.sentiment[slant]) * 100)}%`
    },

    handleCommentChange: _.debounce(function() {
      window.localStorage.setItem(this.commentStorageKey, this.commentText)

      Algorithmia.client("sim7BOgNHD5RnLXe/ql+KUc0O0r1")
        .algo("nlp/SocialSentimentAnalysis/0.1.4")
        .pipe({ sentence: this.commentText })
        .then(resp => {
          this.comment.sentiment = resp.result[0]

          this.$store.commit('setComment', {
            sectionName: this.section,
            text: this.commentText,
            word_count: this.wordCount(this.commentText),
            bad_word_count: this.badWordCount,
            sentiment: this.comment.sentiment,
          })
        })

      Algorithmia.client("sim7BOgNHD5RnLXe/ql+KUc0O0r1")
        .algo("nlp/ProfanityDetection/1.0.0")
        .pipe([this.commentText, ['suck', 'sucks'], false])
        .then(resp => {
          this.detectedProfanity = resp.result

          this.$store.commit('setComment', {
            sectionName: this.section,
            text: this.commentText,
            word_count: this.wordCount(this.commentText),
            bad_word_count: this.badWordCount,
            sentiment: this.comment.sentiment,
          })
        });
    }, 500),
  },

  mounted () {
    if (!!this.submission.id)
      this.initiateComment()
  },
}
</script>

<style lang="scss" scoped>
  .grid,
  .col--sticky {
    background: white;
  }

  .refer-to {
    font-size: 0.9rem;
    font-style: italic;
    margin: 0;
  }

  textarea {
    width: 100%;
    height: 35vh;
    margin: 0 0 1rem;
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
