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
}
</script>

<style scoped>
  .stepper {
    margin-bottom: 1.5rem;
    background: white;
  }

  .stepper__step {
    opacity: 0.5;
    transition: opacity 0.2s;
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
