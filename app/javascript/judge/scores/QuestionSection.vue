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
      <h3 class="mb-2">{{ commentTitle | capitalize }} Feedback for Students</h3>

      <div class="border-l-2 border-energetic-blue bg-blue-50 p-2 mb-4">
        <h4 class="text-base mb-2 font-bold">Please Keep in Mind</h4>

        <slot name="comment-tips" />
      </div>

      <div class="flex justify-between mb-1 ml-1 mr-2">
        <p class="text-base italic">Please write at least {{ minWordCount }} words</p>

        <p class="text-base font-bold" :style="`color: ${colorForWordCount}`">
          {{ wordCount }}
          {{ wordCount | pluralize('word') }}
        </p>
      </div>

      <textarea ref="commentText" :value="comment.text" @input="updateCommentText" class="w-full h-36" />

      <div class="flex justify-between mt-6">
        <div>
          <router-link
            v-if="!!prevSection"
            v-on:click.native="handleCommentChange"
            :to="{ name: prevSection }"
            class="link-button link-button-success font-bold"
          >
            Back: {{ prevBtnTxt }}
          </router-link>
        </div>

        <div>
          <span v-tooltip="nextDisabledMsg">
            <router-link
              v-if="!!nextSection"
              v-on:click.native="handleCommentChange"
              :to="{ name: nextSection }"
              :disabled="goingNextIsDisabled"
              class="link-button link-button-success font-bold"
            >
              Next: {{ nextBtnTxt }}
            </router-link>
          </span>
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

    commentTitle () {
      return this.$store.getters.section(this.section).title
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
