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

        <div class="panel">
          <h6>If something is broken:</h6>

          <p>
            Complete as much of the score as you can and
            <a :href="emailSupport">email us</a>.
            If the team is able to fix the issue,
            we will email you back and you will be able
            to update the score.
          </p>

          <h6>Finishing a score:</h6>

          <p>
            Even after finishing a score, you have
            until <strong v-html="deadline"></strong> to make
            changes.
          </p>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { mapState } from 'vuex'

import Icon from '../../components/Icon'

export default {
  computed: {
    ...mapState([
      'team',
      'submission',
      'deadline',
    ]),

    emailSupport() {
      const subject = `Errors while judging submission "${this.submission.name}" by ${this.team.name}`

      return `mailto:${process.env.HELP_EMAIL}?subject=${subject}`
    },
  },

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

  h6 {
    margin: 1rem 0 0;
  }
</style>
