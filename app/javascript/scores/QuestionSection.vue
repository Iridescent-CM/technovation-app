<template>
  <div>
    <h1>{{ title }}</h1>

    <p>Refer to the {{ referTo }}</p>

    <score-entry :questions="questions"></score-entry>

    <div class="grid grid--bleed grid--justify-space-between">
      <button
        v-if="!!prevSection"
        class="button button--small btn-prev"
        @click="$store.commit('changeSection', prevSection)"
      >
        Back: {{ prevBtnTxt }}
      </button>

      <button
        v-if="!!nextSection"
        class="button button--small btn-next"
        @click="$store.commit('changeSection', nextSection)"
      >
        Next: {{ nextBtnTxt }}
      </button>
    </div>
  </div>
</template>

<script>
import _ from 'lodash'
import ScoreEntry from './ScoreEntry'

export default {
  name: 'QuestionSection',

  computed: {
    nextBtnTxt () {
      return _.capitalize(this.nextSection)
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
    'questions',
  ],

  components: {
    ScoreEntry,
  },
}
</script>
