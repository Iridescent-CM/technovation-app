<template>
  <div class="grid grid--align-start grid--justify-space-between ">
    <div :class="solo ? 'grid__col-md-6' : 'grid__col-12'">
      <h3>{{ title }}</h3>

      <slot name="section-summary" />

      <score-entry :questions="questions">
        <slot />
      </score-entry>
    </div>

    <div :class="solo ? 'grid__col-md-6' : 'grid__col-12'">
      <h3>{{ section | capitalize }} comment</h3>

      <h5 class="heading--reset">Please keep in mind</h5>

      <slot name="comment-tips" />

      <div class="grid grid--bleed grid--justify-space-between">
        <div class="grid__col-6"></div>

        <div class="grid__col-6">
          <p class="word-count">
            <span :style="`color: ${colorForWordCount}`">
              {{ wordCount }}
              {{ wordCount | pluralize('word') }}
            </span>

            <br>

            <span class="font-weight--300">Please write at least {{ minWordCount }} words</span>
          </p>
        </div>
      </div>

      <textarea ref="commentText" :value="comment.text" @input="updateCommentText" />

      <div class="grid grid--bleed grid--justify-space-between">
        <div class="grid__col-6 nav-btns--left">
          <p>
            <router-link
              v-if="!!prevSection"
              v-on:click.native="handleCommentChange"
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
                v-on:click.native="handleCommentChange"
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
import capitalize from 'lodash/capitalize'
import { mapState, mapGetters } from 'vuex'

import { debounce } from '../../utilities/utilities'
import ScoreEntry from './ScoreEntry'

export default {
  name: 'QuestionSection',

  data () {
    return {
      commentInitiated: false,
    }
  },

  watch: {
    commentText () {
      this.$nextTick(() => {
        this.$store.commit('setComment', {
          sectionName: this.section,
          word_count: this.wordCount,
        })

        this.debouncedCommentWatcher()
      })
    },

    commentStorageKey () {
      this.initiateComment()
    },
  },

  computed: {
    ...mapState(['submission']),
    ...mapGetters(['sectionQuestions']),

    title () {
      var section = this.$store.getters.section(this.section)
      return section.title + ' (' + section.pointsPossible + ' points)'
    },

    comment () {
      return this.$store.getters.comment(this.section)
    },

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
      return this.wordCount < this.minWordCount
    },

    minWordCount() {
      return (this.section == 'overall') ? 40 : 20
    },

    wordCount () {
      let text = this.commentText

      if (!this.commentText) text = ''

      return text.split(' ').filter(word => {

        return word.split('').filter(char => {
          return char.match(/\w/)
        }).length

      }).length
    },

    colorForWordCount () {
      if (this.wordCount >= this.minWordCount) {
        return 'darkgreen'
      } else if (this.wordCount >= (66 / 100) * this.minWordCount) {
        return 'goldenrod'
      } else if (this.wordCount >= (33 / 100) * this.minWordCount) {
        return 'orange'
      } else {
        return 'darkred'
      }
    },

    questions () {
      return this.sectionQuestions(this.section)
    },

    commentStorageKey () {
      return `${this.section}-comment-${this.submission.id}`
    },

    nextBtnTxt () {
      return this.nextButtonText || capitalize(this.nextSection)
    },

    prevBtnTxt () {
      return this.prevButtonText || capitalize(this.prevSection)
    },
  },

  props: [
    'nextSection',
    'prevSection',
    'section',
    'nextButtonText',
    'prevButtonText',
    'solo',
  ],

  components: {
    ScoreEntry,
  },

  methods: {
    initiateComment () {
      let comment = Object.assign({}, this.comment, { sectionName: this.section })

      if (!comment.text) {
        comment.text = ''
      }

      this.$store.commit('setComment', comment)

      this.commentInitiated = true
    },

    handleCommentChange () {
      if (this.commentInitiated) {
        if (this.commentText.length) {
          this.saveComment()
        } else {
          this.$store.commit('resetComment', this.section)
          this.saveComment()
        }
      }
    },

    updateCommentText (e) {
      this.$store.commit('setComment', {
        sectionName: this.section,
        text: e.target.value,
      })
    },

    saveComment () {
      this.$store.commit('saveComment', this.section)
    },
  },

  mounted () {
    if (!!this.submission.id)
      this.initiateComment()
  },

  created () {
    this.debouncedCommentWatcher = debounce(() => {
      this.handleCommentChange()
    }, 500)
  }
}
</script>

<style lang="scss" scoped>
  .grid {
    background: white;
  }

  .help-text {
    font-size: 1.3rem;
    font-style: italic;
    margin: 0;
  }

  textarea {
    width: 100%;
    height: 35vh;
    margin: 0;
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

  .font-weight--300 {
    font-weight: 300;
  }
</style>
