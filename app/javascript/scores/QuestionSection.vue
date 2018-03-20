<template>
  <div>
    <h1>{{ title }}</h1>

    <p>Refer to the {{ referTo }}</p>

    <score-entry :questions="questions">
      <slot />
    </score-entry>

    <textarea v-model="comment" />

    <div class="grid grid--bleed grid--justify-space-between">
      <div class="grid__col-auto">
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

      <div class="grid__col-auto">
        <p>
          <router-link
            v-if="!!nextSection"
            :to="{ name: nextSection }"
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
    }
  },

  watch: {
    comment (val) {
      if (!!val) window.localStorage.setItem(this.commentStorageKey, val)

      this.$store.commit('setComment', {
        sectionName: this.section,
        text: this.comment,
      })
    },

    //
    // FIXME hacky watcher to fill comment after
    // remote score data is loaded
    //
    submissionId () {
      this.comment = this.$store.getters.comment(this.section)

      if (!this.comment) {
        const comment = window.localStorage.getItem(
          this.commentStorageKey
        )

        if (!!comment) this.comment = comment
      }
    },
  },

  computed: {
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
</style>
