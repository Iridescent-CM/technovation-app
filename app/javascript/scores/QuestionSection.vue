<template>
  <div>
    <h1>{{ title }}</h1>

    <p>Refer to the {{ referTo }}</p>

    <score-entry :questions="questions"></score-entry>

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
