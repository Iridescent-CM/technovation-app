<template>
  <div class="grid dashboard-notices">
    <div class="grid__col-sm-6 grid__col--bleed-y">
      <div class="grid__cell">
        <h1 class="page-heading">
          Student Dashboard

          <small>
            <a href="https://iridescentlearning.org/internet-safety/" target="_blank">
              Internet Safety Training
            </a>
          </small>
        </h1>
      </div>
    </div>

    <div class="grid__col-sm-6 grid__col--bleed-y grid--align-end">
      <div class="grid__cell">
        <h1 class="page-heading">
          {{ currentAccount.name }}

          <slot name="survey-links"></slot>

          <small>
            <drop-down label="More Information">
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

const { mapState } = createNamespacedHelpers('authenticated')

export default {
  name: 'dashboard-header',

  components: {
    DropDown,
    Icon,
  },

  computed: mapState(['currentAccount']),
}
</script>
