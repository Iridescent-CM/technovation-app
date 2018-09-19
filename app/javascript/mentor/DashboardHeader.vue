<template>
  <div class="grid dashboard-notices">
    <div class="grid__col-sm-6 grid__col--bleed-y">
      <div v-if="regionalAmbassadorHasProvidedIntro" class="grid__cell">
        <h1 class="page-heading">
          <img
            :src="regionalAmbassadorAvatarUrl"
            class="profile-image"
            width="40"
            height="40"
          />
          {{ regionalAmbassadorName }}

          <small>
            <drop-down label="Meet your Regional Ambassador">
              <slot name="ra-intro" />
            </drop-down>
          </small>
        </h1>
      </div>

      <div v-else class="grid__cell">
        <h1 class="page-heading">
          Mentor Dashboard
          <small><slot name="survey-links" /></small>
          <small><slot name="ra-switch-link" /></small>
          <small><slot name="judge-switch-link" /></small>
        </h1>
      </div>
    </div>

    <div class="grid__col-sm-6 grid__col--bleed-y grid--align-end">
      <div class="grid__cell">
        <h1 class="page-heading">
          <img
            :src="currentAccountAvatarUrl"
            class="profile-image"
            width="40"
            height="40"
          />

          {{ currentAccountName }}

          <small><slot name="ra-switch-link" /></small>
          <small><slot name="judge-switch-link" /></small>

          <small>
            <drop-down label="More Information">
              <h6>
                Curriculum
                <small>
                  <a
                    href="https://www.technovationchallenge.org/curriculum-intro/registered"
                    target="_blank"
                  >Open the Technovation Curriculum</a>
                </small>
              </h6>

              <h6>
                Help us improve!
                <small>
                  <slot name="survey-links" />
                </small>
              </h6>

              <h6>
                Submission Guide
                <small>
                  <a
                    href="https://www.technovationchallenge.org/submission-guidelines/"
                    target="_blank"
                  >Read the Submission Guidelines</a>
                </small>
              </h6>

              <h6>
                Judging Rubric
                <small>
                  <a
                    href="https://www.technovationchallenge.org/judging-rubric/"
                    target="_blank"
                  >Read the Judging Rubric</a>
                </small>
              </h6>

              <slot></slot>
            </drop-down>
          </small>
        </h1>
      </div>
    </div>
  </div>
</template>

<script>
import { createNamespacedHelpers } from 'vuex'

import DropDown from 'components/DropDown'
import Icon from 'components/Icon'

const { mapGetters } = createNamespacedHelpers('authenticated')

export default {
  name: 'dashboard-header',

  components: {
    DropDown,
    Icon,
  },

   computed: mapGetters([
    'currentAccountName',
    'currentAccountAvatarUrl',
    'regionalAmbassadorName',
    'regionalAmbassadorAvatarUrl',
    'regionalAmbassadorHasProvidedIntro',
  ]),
}
</script>

<style lang="scss" scoped>
.page-heading {
  background: #ececec;
}

.profile-image {
  width: 40px;
  clip-path: circle(20px at center);
}
</style>