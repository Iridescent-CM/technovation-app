<template>
  <div class="mb-10">
    <p class="font-bold text-3xl">{{ team.name | capitalize}}</p>
    <div class="flex flex-col lg:flex-row gap-x-8 mt-4">
      <div class="w-full lg:w-1/4">
        <!--    <img :src="team.photo"/>-->
        <img class="h-full object-cover rounded-tr-2xl rounded-bl-2xl" src="https://cdn.vox-cdn.com/thumbor/Ndb49Uk3hjiquS041NDD0tPDPAs=/0x169:1423x914/fit-in/1200x630/cdn.vox-cdn.com/uploads/chorus_asset/file/7342855/microsoftteams.0.jpg"/>
      </div>

      <div class="mt-6">
        <p class="font-bold text-3xl text-energetic-blue rubik">{{ team.division | uppercase }} DIVISION</p>
        <p class="font-bold text-3xl text-energetic-blue rubik">{{ submission.development_platform }}</p>
        <p>
          <span><icon
              size="20"
              name="map-marker"
              class="inline"
              color="0075cf"
          />
          {{ team.location | capitalize }}</span>
        </p>
        <p>
          <span><icon
              size="20"
              name="code"
              class="inline"
              color="0075cf"
          />
          {{ submission.development_platform | capitalize }}</span>
        </p>
      </div>
    </div>
  </div>

</template>

<script>
import { mapState } from 'vuex'

import JudgeRecusalPopup from './JudgeRecusalPopup'
import Icon from '../../components/Icon'

export default {
  computed: {
    ...mapState([
      'team',
      'score',
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
    JudgeRecusalPopup
  },
}
</script>