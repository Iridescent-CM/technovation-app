<template>
  <div class="grid">
    <div class="grid__col-12 grid__col--bleed">
      <h1>Review submission</h1>
    </div>

    <div class="grid__col-3 grid__col--bleed-y">
      <img :src="team.photo" />

      <h3>{{ team.name }}</h3>

      <ul class="list--reset">
        <li><icon size="16" name="flag-o" />
          {{ team.division }}
        </li>

        <li><icon size="16" name="globe" />{{ team.location }}</li>

        <li>
          <icon size="16" name="code-fork" />
          {{ submission.development_platform }}
        </li>
      </ul>
    </div>

    <div class="grid__col-9 grid__col--bleed-y">
      <h1>{{ submission.name }}</h1>
      <div class="app-description" v-html="submission.description"></div>
    </div>
  </div>
</template>

<script>
import { mapState } from 'vuex'
import Icon from '../../components/Icon'

export default {
  computed: mapState([
    'team',
    'submission',
  ]),

  components: {
    Icon,
  },
}
</script>

<style>
  .app-description p {
    margin: 1rem 0;
  }
</style>
