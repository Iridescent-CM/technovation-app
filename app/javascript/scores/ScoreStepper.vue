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
         $route.name === section.name ? 'stepper__step--active' : ''
      ]"
      v-for="section in sections"
    >
      <router-link :to="{ name: section.name }" class="grid__cell">
        <span class="stepper__step-number">{{ section.stepNum }}</span>
        {{ section.title }}

        <span class="stepper__step-score">
          {{ section.pointsTotal }} / {{ section.pointsPossible }}
        </span>
      </router-link>
    </div>
  </nav>
</template>

<script>
export default {
  computed: {
    sections () {
      return [
        {
          name: 'ideation',
          title: 'Ideation',
          stepNum: 2,
          pointsTotal: this.pointsTotal('ideation'),
          pointsPossible: this.pointsPossible('ideation'),
        },

        {
          name: 'technical',
          title: 'Technical',
          stepNum: 3,
          pointsTotal: this.pointsTotal('technical'),
          pointsPossible: this.pointsPossible('technical'),
        },

        {
          name: 'pitch',
          title: 'Pitch',
          stepNum: 4,
          pointsTotal: this.pointsTotal('pitch'),
          pointsPossible: this.pointsPossible('pitch'),
        },

        {
          name: 'entrepreneurship',
          title: 'Entrepreneurship',
          stepNum: 5,
          pointsTotal: this.pointsTotal('entrepreneurship'),
          pointsPossible: this.pointsPossible('entrepreneurship'),
        },

        {
          name: 'overall',
          title: 'Overall Impression',
          stepNum: 6,
          pointsTotal: this.pointsTotal('overall'),
          pointsPossible: this.pointsPossible('overall'),
        },
      ]
    },
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
