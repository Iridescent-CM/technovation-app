<template>
  <div>
    <h3 class="mb-2 font-semibold">{{ title }}</h3>

    <div class="border-l-2 border-energetic-blue bg-blue-50 p-2">
      <slot name="section-summary" />
    </div>

    <score-entry :questions="questions">
      <slot />
    </score-entry>

    <h3 class="mt-8 mb-2 font-semibold">{{ commentTitle | capitalize }} Feedback for Students</h3>

    <div class="border-l-2 border-energetic-blue bg-blue-50 p-2 mb-6">
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

    <div class="flex justify-between mt-12">
      <div>
        <router-link
          v-if="!!prevSection"
          v-on:click.native="handleCommentChange"
          :to="{ name: prevSection }"
          :class="prevSectionIsIncomplete ? 'link-button-success' : 'link-button-neutral'"
          class="link-button md-link-button"
        >
          Back
        </router-link>
      </div>

      <div>
        <router-link
          v-if="!!nextSection"
          v-on:click.native="handleCommentChange"
          :to="{ name: nextSection }"
          class="link-button link-button-success md-link-button"
        >
          Next
        </router-link>
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

    prevSectionIsIncomplete () {
      if (this.prevSection === 'overview') {
        return false
      } else {
        return !this.$store.getters.isSectionComplete(this.prevSection)
      }
    },

    minWordCount() {
      return 20
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
        return '#43b02a';
      } else if (this.wordCount >= (66 / 100) * this.minWordCount) {
        return '#eab308'
      } else if (this.wordCount >= (33 / 100) * this.minWordCount) {
        return '#f97316'
      } else {
        return '#ef4444'
      }
    },

    questions () {
      return this.sectionQuestions(this.section)
    },

    commentStorageKey () {
      return `${this.section}-comment-${this.submission.id}`
    },
  },

  props: [
    'nextSection',
    'prevSection',
    'section',
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
