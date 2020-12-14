<template>
  <div class="grid dashboard-notices">
    <div class="grid__col-sm-6 grid__col--bleed-y">
      <div v-if="chapterAmbassadorHasProvidedIntro" class="grid__cell">
        <h1 class="page-heading">
          <img
            :src="chapterAmbassadorAvatarUrl"
            class="profile-image"
            width="40"
            height="40"
          />
          {{ regionalProgramName }}

          <small>
            <drop-down label="Meet your Chapter Ambassador">
              <slot name="chapter-ambassador-intro" />
            </drop-down>
          </small>
        </h1>
      </div>

      <div v-else class="grid__cell">
        <h1 class="page-heading">
          {{ defaultTitle }}

          <small v-if="surveyLink">
            <a :href="surveyLink" target="_blank">{{ surveyLinkText }}</a>
          </small>
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

          <slot name="right-sidebar" />

          <small>
            <drop-down label="Helpful Links">
              <h6
                v-for="link in resourceLinks"
                v-if="link.text.length && link.url.length"
              >
                {{ link.heading }}
                <small>
                  <a :href="link.url" target="_blank">{{ link.text }}</a>
                </small>
              </h6>
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

  props: {
    defaultTitle: {
      type: String,
      required: false,
      default: 'Your Dashboard',
    },

    resourceLinks: {
      type: Array,
      required: false,
      default () { return [] },
    }
  },

  computed: {
    ...mapGetters([
      'currentAccountName',
      'currentAccountAvatarUrl',
      'regionalProgramName',
      'chapterAmbassadorAvatarUrl',
      'chapterAmbassadorHasProvidedIntro',
    ]),

    surveyLink () {
      return this.surveyLinkFromResources.url
    },

    surveyLinkText () {
      return this.surveyLinkFromResources.text
    },

    surveyLinkFromResources () {
      return Object.assign({}, this.resourceLinks.filter(l => l.isSurveyLink)[0])
    },
  },
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
