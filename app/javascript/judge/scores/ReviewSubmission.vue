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

    <div class="grid__col-9 grid__col--bleed-y submission-review">
      <h1>{{ submission.name }}</h1>

      <div class="app-description" v-html="submission.description"></div>


      <div class="submission-pieces__screenshots">
        <div
          v-for="screenshot in submission.screenshots"
          class="submission-pieces__screenshot"
        >
          <img
            class="img-modal"
            :src="screenshot.thumb"
            :data-modal-url="screenshot.full"
          />
        </div>
      </div>

      <div class="grid grid--bleed">
        <div class="grid__col-6">
          <h3>Pitch</h3>

          <p>
            <a
              href="#"
              :data-opens-modal="`video-modal-${submission.demo_video_id}`"
              :data-modal-fetch="submission.demo_video_url"
            >
              <icon name="play-circle-o" />
              Watch the demo video
            </a>
          </p>

          <div
            class="modal"
            :id="`video-modal-${submission.demo_video_id}`"
          >
            <div class="modal-content"></div>
          </div>

          <p>
            <a
              href="#"
              :data-opens-modal="`video-modal-${submission.pitch_video_id}`"
              :data-modal-fetch="submission.pitch_video_url"
            >
              <icon name="play-circle-o" />
              Watch the pitch video
            </a>
          </p>

          <div
            class="modal"
            :id="`video-modal-${submission.pitch_video_id}`"
          >
            <div class="modal-content"></div>
          </div>
        </div>

        <div class="grid__col-6">
          <h3>Code</h3>

          <a :href="submission.source_code_url" target="_blank">
            Download the source code
          </a>

          <p>
            {{ team.name }} earned

            <strong>
              {{ submission.total_checklist_points }}
              {{ submission.total_checklist_points | pluralize('point') }}
            </strong>

            for their code checklist.
          </p>
        </div>

        <div class="grid__col-6">
          <h3>Business</h3>

          <template v-if="team.division === 'senior'">
            <a :href="submission.business_plan_url" target="_blank">
              Read the business plan
            </a>
          </template>

          <template v-else>
            Junior Division teams do not upload a business plan.
          </template>
        </div>

        <div v-if="team.live_event" class="grid__col-6">
          <h3>Regional Pitch Events</h3>

          <p>
            <a :href="submission.pitch_presentation_url" target="_blank">
              Open the pitch presentation slides
            </a>
          </p>
        </div>
      </div>

      <div class="grid grid--bleed grid--justify-space-around">
        <div class="grid__col-12 grid--align-center">
          <hr />

          <h6>Notes for judges:</h6>

          <p class="scent--strong">
            If any part of the submission is broken, please
            <a :href="mailToHelp">email us</a> and complete
            as much of the score as you can. We will give the
            team a chance to correct any simple, technical mistakes.
            If the team is able to fix the issue, we will email you
            back and you will be able to update the score.
          </p>

          <p>
            Even after &#8220;finishing&#8221; a score,
            you have until May 20<sup>th</sup> to make changes.
            You may find that scoring a few submissions
            will help you calibrate your expectations.
          </p>

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
import Icon from '../../components/Icon'

export default {
  computed: {
    ...mapState([
      'team',
      'submission',
    ]),

    mailToHelp () {
      return 'mailto:help@technovationchallenge.org?subject=' +
             'Errors while judging'
    },
  },

  components: {
    Icon,
  },

  methods: {
  },
}
</script>

<style>
  #judge-scores-app h2 {
    margin: 1rem 0;
  }

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

  .scent--strong a {
    color: black;
    font-weight: bold;
  }

  .scent--strong a:hover {
    text-decoration: underline;
  }
</style>
