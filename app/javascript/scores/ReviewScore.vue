<template>
  <div class="grid grid--bleed grid--justify-space-around">
    <div class="grid__col-6">
      <div class="panel">
        <h1>Review your score</h1>

        <router-link
          :to="{ name: name }"
          v-tooltip.top-center="`Make changes to your ${name} score`"
          v-for="name in sectionNames"
          class="grid row"
        >
          <div class="grid__col-11">
            <p>
              {{ name | capitalize }}

            </p>
          </div>

          <div class="grid__col-1">
            {{ totalPoints(name) }}
          </div>
        </router-link>

        <div class="grid row row--bottom">
          <div class="grid__col-11">
            Final total score
          </div>

          <div class="grid__col-1">
            {{ totalScore }}
          </div>
        </div>
      </div>

      <div class="grid grid--bleed grid--justify-space-around">
        <div class="grid__col-auto">
          <p class="align-center">
            <a
             :href="`/judge/score_completions?id=${scoreId}`"
              class="button"
              data-method="post"
              v-tooltip.top-center="'You can revisit your finished scores and make changes through May 20th.'"
            >
              Finish score
            </a>
          </p>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  data () {
    return {
      sectionNames: [
        'ideation',
        'technical',
        'pitch',
        'entrepreneurship',
        'overall',
      ],
    }
  },

  computed: {
    scoreId () {
      return this.$store.getters.scoreId
    },

    totalScore () {
      return this.$store.getters.totalScore
    },
  },

  methods: {
    totalPoints (sectionName) {
      return this.$store.getters.sectionPointsTotal(sectionName)
    },
  },
}
</script>

<style lang="scss" scoped>
  .panel {
    padding: 0;

    h1 {
      margin: 1rem 0;
    }
  }

  .row {
    color: black;
    padding: 0.5rem 1rem;

    &:nth-child(even) {
      background: DarkSeaGreen;
    }

    &:not(.row--bottom) {
      opacity: 0.8;
      transition: opacity 0.2s;

      &:hover {
        opacity: 1;
      }
    }

    div {
      display: flex;
      justify-content: center;
      flex-direction: column;

      &.grid__col-1 {
        font-size: 2rem;
        color: #666;
        font-weight: bold;
        text-align: center;
      }
    }
  }

  .align-center {
    text-align: center;
  }
</style>
