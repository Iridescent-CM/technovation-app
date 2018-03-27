<template>
  <div class="grid__col-3 grid__col--bleed-y col--sticky-parent">
    <div class="col--sticky-spacer">
      <div class="col--sticky">
        <div class="panel">
          <img :src="team.photo" class="grid__cell-img" />

          <h3>{{ team.name }}</h3>

          <ul class="list--reset">
            <li><icon size="16" name="flag-o" />
              {{ team.division | capitalize }} Division
            </li>

            <li><icon size="16" name="globe" />{{ team.location }}</li>

            <li>
              <icon size="16" name="code-fork" />
              {{ submission.development_platform }}
            </li>
          </ul>
        </div>
      </div>
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

<style scoped>
  h3 {
    font-size: 1.1rem;
  }

  ul {
    font-size: 0.9rem;
  }
</style>

