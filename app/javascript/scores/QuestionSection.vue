<template>
  <div>
    <h1>{{ title }}</h1>

    <p>Refer to the {{ referTo }}</p>

    <score-entry :questions="questions">
      <slot />
    </score-entry>

    <h2 class="heading--reset">{{ sectionTitle}} comment</h2>

    <p>Reminder to be nice goes here.</p>

    <p>Please write at least 40 words</p>

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


    <p class="word-count">
      <span :style="`color: ${colorForWordCount}`">
        {{ wordCount(comment) }}
      </span>
      {{ words }}
    </p>

    <div class="grid grid--bleed grid--justify-space-between">
      <div class="grid__col-auto nav-btn">
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

      <div class="grid__col-auto nav-btn">
        <p>
          <router-link
            v-if="!!nextSection"
            :to="{ name: nextSection }"
            :disabled="wordCount(comment) < 40"
            class="button button--small btn-next"
          >
            Next: {{ nextBtnTxt }}
          </router-link>
        </p>
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

    words () {
      return this.wordCount(this.comment) === 1 ? 'word' : 'words'
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
  p {
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

  .nav-btn:nth-child(2) {
    text-align: right;
  }

  p.word-count {
    text-align: right;
    font-size: 1rem;
    font-weight: bold;
    margin: 0.5rem 0;
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
