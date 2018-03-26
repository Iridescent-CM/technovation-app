<template>
  <div class="grid">
    <div class="grid__col-12 grid__col--bleed-y">
      <h2>Review submission</h2>
    </div>

    <div
      class="
        grid__col-3
        grid__col--bleed-y
        col--sticky-parent
        team-info
      "
    >
      <div class="col--sticky-spacer">
        <div class="col--sticky">
          <div class="panel">
            <img :src="team.photo" class="grid__cell-img" />

            <h3>{{ team.name }}</h3>

            <ul class="list--reset font-small">
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
        </div>
      </div>
    </div>

    <div class="grid__col-9 grid__col--bleed-y submission-review">
      <h1>{{ submission.name }}</h1>
      <div class="app-description" v-html="submission.description"></div>
    </div>

    <div class="grid__col-12 grid--align-center grid__col--bleed">
      <p>
        <router-link
          :to="{ name: 'ideation' }"
          class="button"
        >
          Start scoring
        </router-link>
      </p>
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

  methods: {
  },
}
</script>

<style>
  .app-description p {
    margin: 1rem 0;
  }

  .team-info h3 {
    font-size: 1.1rem;
  }

  .font-small {
    font-size: 0.9rem;
  }

  .submission-review h1 {
    border-bottom: 1px solid #5ABF94;
  }
</style>
