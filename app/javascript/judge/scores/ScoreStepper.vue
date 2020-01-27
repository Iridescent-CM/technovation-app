<template>
  <nav class="grid grid--bleed grid--justify-space-around stepper">
    <div
      :class="[
        'grid__col-auto',
        'stepper__step',
        $route.name === 'review-submission' ?
                          'stepper__step--active' : ''
      ]"
    >
      <router-link
        :to="{ name: 'review-submission' }"
        class="grid__cell"
      >
        <span class="stepper__step-number">1</span>
        Review submission
      </router-link>
    </div>

    <div
      :class="[
        'grid__col-auto',
        'stepper__step',
        $route.name === section.name ? 'stepper__step--active' : ''
      ]"
      v-for="(section, i) in sections"
      :key="i"
    >
      <router-link
        :to="{ name: section.name }"
        class="grid__cell"
      >
        <span class="stepper__step-number">
          {{ i + 2 }}
        </span>

        {{ section.title }}

        <span class="stepper__step-score">
          {{ section.pointsTotal }} / {{ section.pointsPossible }}
        </span>
      </router-link>
    </div>

    <div
      :class="[
        'grid__col-auto',
        'stepper__step',
        $route.name === 'review-score' ? 'stepper__step--active' : ''
      ]"
    >
      <router-link
        :to="{ name: 'review-score' }"
        class="grid__cell"
      >
        <span class="stepper__step-number">{{ lastStepNum }}</span>
        Review score

        <span class="stepper__step-score">
          {{ totalScore }} / {{ totalPossible }}
        </span>
      </router-link>
    </div>
  </nav>
</template>

<script>
import { mapState } from 'vuex'

export default {
  computed: {
    ...mapState(['team']),

    lastStepNum () {
      // review-submission + sections + review-score
      return 1 + this.sections.length + 1
    },

    sections () {
      return this.$store.getters.sections
    },

    totalScore () {
      return this.$store.getters.totalScore
    },

    totalPossible () {
      return this.$store.getters.totalPossible
    },
  },
}
</script>

<style scoped>
  .stepper {
    background: white;
    font-size: 100%;
    box-shadow: 0 0.2rem 0.2rem rgba(0, 0, 0, 0.3);
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
    padding: 1rem 0;
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
