<template>
  <div v-if="!submission.id" class="loading">
    <icon name="spinner" className="spin" />
    <div>Finding a submission for you to judge...</div>
  </div>

  <div v-else class="grid">
    <div class="grid__col-12 grid__col--bleed-y">
      <h2>Review submission</h2>
    </div>

    <team-info />

    <div class="grid__col-9 grid__col--bleed-y">
      <h1 class="border--b-thin-primary">{{ submission.name }}</h1>

      <div class="app-description" v-html="submission.description"></div>

      <screenshots />

      <div class="grid grid--bleed submission-pieces primary-row">
        <pitch />
        <tc-code />
      </div>

      <div class="grid grid--bleed submission-pieces white-row">
        <business />

        <presentation />
      </div>

      <div class="grid grid--bleed grid--justify-space-around">
        <div class="grid__col-12 grid--align-center">
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
    </div>
  </div>
</template>

<script>
import { mapState } from 'vuex'
import Icon from '../../../components/Icon'

import TeamInfo from '../TeamInfo'
import Screenshots from '../pieces/Screenshots'
import Pitch from '../pieces/Pitch'
import TcCode from '../pieces/Code'
import Business from '../pieces/Business'
import Presentation from '../pieces/Presentation'

export default {
  computed: {
    ...mapState([
      'team',
      'submission',
    ]),
  },

  components: {
    Icon,
    TeamInfo,
    Screenshots,
    Pitch,
    TcCode,
    Business,
    Presentation,
  },
}
</script>

<style lang="scss">
  #judge-scores-app h2 {
    margin: 1rem 0;
  }

  .app-description p {
    margin: 1rem 0;
  }

  .scent--strong {
    a {
      color: black;
      font-weight: bold;

      &:hover {
        text-decoration: underline;
      }
    }
  }

  .submission-pieces h4 {
    margin: 0;
  }

  .primary-row {
    background: #903D54;
    color: white;
    padding: 1rem;
    min-height: 240px;
    -webkit-font-smoothing: antialiased;

    a {
      color: #e6e6e5;
      font-weight: bold;
      transition: transform 0.2s;

      &:hover {
        transform: scale(1.05);
      }
    }

    > div {
      align-self: center;
    }
  }

  .white-row,
  .grid--bleed [class*="grid__col-"].white-row {
    background: white;
    padding: 1rem;
    min-height: 240px;

    > div,
    > h4 + div {
      align-self: center;
    }
  }

  .loading {
    padding: 2rem;
    text-align: center;

    div {
      margin: 1rem auto;
    }
  }
</style>
