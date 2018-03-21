<template>
  <div class="grid grid--justify-space-between">
    <div class="grid__col-auto">
      <h3>{{ title }}</h3>

      <p class="refer-to">Refer to the {{ referTo }}</p>

      <score-entry :questions="questions">
        <slot />
      </score-entry>
    </div>

    <div class="grid__col-6">
      <h3 class="heading--reset">{{ sectionTitle}} comment</h3>

      <h5 class="heading--reset">Please keep in mind</h5>

      <slot name="comment-tips" />

      <textarea v-model="comment" />

      <div class="comment-sentiment">
        <div
          v-tooltip.top-center="`Positive sentiment of your comment`"
          :style="`width: ${sentiment.positive * 100}%`"
        ></div>

        <div
          v-tooltip.top-center="`Negative sentiment of your comment`"
          :style="`width: ${sentiment.negative * 100}%`"
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
            </span>
            {{ wordCount(comment) | pluralize('word') }}

            <br />

            <span :style="`color: ${colorForBadWordCount}`">
              {{ badWordCount }}
            </span>
            {{ badWordCount | pluralize('prohibited word') }}
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

import ScoreEntry from './ScoreEntry'

export default {
  name: 'QuestionSection',

  data () {
    return {
      comment: '',

      sentiment: {
        negative: 0.5,
        positive: 0.5,
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

    sectionTitle () {
      return _.capitalize(this.section)
    },

    questions () {
      return this.$store.getters.sectionQuestions(this.section)
    },

    commentStorageKey () {
      return `${this.section}-comment-${this.submissionId}`
    },

    submissionId () {
      return this.$store.getters.submissionId
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
    handleCommentChange: _.debounce(function(current_val, old_val) {
      if (current_val !== old_val) {
        window.localStorage.setItem(this.commentStorageKey, current_val)

        this.$store.commit('setComment', {
          sectionName: this.section,
          text: current_val,
        })

        $.get(
          'https://api.uclassify.com/v1/uclassify/Sentiment/classify/' +
          '?readKey=0yZrs6zTgHt5&text=' + current_val,
          null,
          resp => { this.sentiment = resp }
        )

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
    width: 100%;
    height: 30vh;
    margin: 1rem 0 0;
    padding: 1rem;
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
      padding: 0.5rem;

      &:first-child {
        background: SteelBlue;
      }
    }
  }
</style>
