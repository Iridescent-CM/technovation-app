<template>
  <nav class="grid grid--bleed grid--justify-space-between stepper">
    <div class="grid__col-auto stepper__step">
      <a class="grid__cell">
        <span class="stepper__step-number">1</span>
        Review submission
      </a>
    </div>

    <div
      :class="[
        'grid__col-auto',
        'stepper__step',
         $route.name === 'ideation' ? 'stepper__step--active' : ''
      ]"
    >
      <router-link to="/ideation" class="grid__cell">
        <span class="stepper__step-number">2</span>
        Ideation

        <span class="stepper__step-score">
          {{ pointsTotal('ideation') }} / {{ pointsPossible('ideation') }}
        </span>
      </router-link>
    </div>

    <div
      :class="[
        'grid__col-auto',
        'stepper__step',
         $route.name === 'technical' ? 'stepper__step--active' : ''
      ]"
    >
      <router-link to="/technical" class="grid__cell">
        <span class="stepper__step-number">3</span>
        Technical

        <span class="stepper__step-score">
          {{ pointsTotal('technical') }} /
          {{ pointsPossible('technical') }}
        </span>
      </router-link>
    </div>

    <div
      :class="[
        'grid__col-auto',
        'stepper__step',
         $route.name === 'pitch' ? 'stepper__step--active' : ''
      ]"
    >
      <router-link to="/pitch" class="grid__cell">
        <span class="stepper__step-number">4</span>
        Pitch

        <span class="stepper__step-score">
          {{ pointsTotal('pitch') }} / {{ pointsPossible('pitch') }}
        </span>
      </router-link>
    </div>

    <div
      :class="[
        'grid__col-auto',
        'stepper__step',
         $route.name === 'entrepreneurship' ? 'stepper__step--active' : ''
      ]"
    >
      <router-link to="/entrepreneurship" class="grid__cell">
        <span class="stepper__step-number">5</span>
        Entrepreneurship

        <span class="stepper__step-score">
          {{ pointsTotal('entrepreneurship') }} /
          {{ pointsPossible('entrepreneurship') }}
        </span>
      </router-link>
    </div>

    <div
      :class="[
        'grid__col-auto',
        'stepper__step',
         $route.name === 'overall' ? 'stepper__step--active' : ''
      ]"
    >
      <router-link to="/overall" class="grid__cell">
        <span class="stepper__step-number">6</span>
        Overall Impression

        <span class="stepper__step-score">
          {{ pointsTotal('overall') }} / {{ pointsPossible('overall') }}
        </span>
      </router-link>
    </div>
  </nav>
</template>

<script>
export default {
  data () {
    return {
    }
  },

  methods: {
    pointsPossible (section) {
      return this.$store.getters.scorePossible(section)
    },

    pointsTotal (section) {
      return this.$store.getters.scoreTotal(section)
    },
  },
}
</script>

<style scoped>
  .stepper {
    margin-bottom: 1.5rem;
    background: white;
    font-size: 100%;
  }

  .stepper__step {
    opacity: 0.5;
    transition: opacity 0.2s;
    white-space: nowrap;
    overflow: hidden;
    flex: 0 1 auto;
    font-size: 0.9rem;
  }

  .stepper__step a {
    text-overflow: ellipsis;
    font-weight: bold;
  }

  .stepper__step-score {
    display: block;
    font-weight: normal;
    font-size: 0.9rem;
    opacity: 0.8;
    text-align: right;
  }

  .stepper__step--active,
  .stepper__step:hover {
    opacity: 1;
  }

  a {
    display: block;
    cursor: pointer;
    padding: 1rem;
    color: black;
  }

  .stepper__step-number {
    font-size: 0.8rem;
    display: inline-block;
    background: darkgreen;
    border-radius: 50%;
    color: white;
    padding: 0.5rem 0.75rem;
  }
</style>
