<template>
  <div>
    <dashboard-header
      default-title="Student Dashboard"
      :resource-links="resourceLinks"
    >
      <div slot="ra-intro"><slot name="ra-intro" /></div>
    </dashboard-header>

    <div class="tabs tabs--vertical tabs--css-only tabs--content-first grid">
      <div class="tabs__content background-color--white grid__col-9">
        <router-view :key="$route.name" :profile-icons="profileIcons">
          <div slot="change-email"><slot name="change-email" /></div>
          <div slot="change-password"><slot name="change-password" /></div>
          <div slot="parental-consent"><slot name="parental-consent" /></div>
          <div slot="find-team"><slot name="find-team" /></div>
          <div slot="create-team"><slot name="create-team" /></div>
          <div slot="find-mentor"><slot name="find-mentor" /></div>
          <div slot="submission"><slot name="submission" /></div>
          <div slot="events"><slot name="events" /></div>
          <div slot="scores"><slot name="scores" /></div>
        </router-view>
      </div>

      <div class="grid__col-3 grid__col--bleed">
        <dashboard-menu
          :regional-pitch-events-enabled="regionalPitchEventsEnabled"
          :scores-and-certificates-enabled="scoresAndCertificatesEnabled"
        />
      </div>
    </div>
  </div>
</template>

<script>
import DashboardHeader from './DashboardHeader'
import DashboardMenu from './DashboardMenu'

export default {
  name: 'app',

  components: {
    DashboardHeader,
    DashboardMenu,
  },

  data () {
    return {
      resourceLinks: [
        {
          heading: 'Safety information',
          url: 'https://iridescentlearning.org/internet-safety/',
          text: 'Internet Safety Training',
        },

        {
          heading: 'Curriculum',
          url: 'https://www.technovationchallenge.org/curriculum-intro/registered',
          text: 'Open the Technovation Curriculum',
        },

        {
          heading: 'Help us improve!',
          url: this.surveyLink,
          text: this.surveyLinkText,
          isSurveyLink: true,
        },

        {
          heading: 'Submission Guide',
          url: 'https://www.technovationchallenge.org/submission-guidelines/',
          text: 'Read the Submission Guidelines',
        },

        {
          heading: 'Judging Rubric',
          url: 'https://www.technovationchallenge.org/judging-rubric/',
          text: 'Read the Judging Rubric',
        },
      ],
    }
  },

  props: {
    surveyLink: {
      type: String,
      required: false,
      default: '',
    },

    surveyLinkText: {
      type: String,
      required: false,
      default: '',
    },

    profileIcons: {
      type: Object,
      default () {
        return {
          profileIconMentor: '',
          profileIconMentorMale: '',
          profileIconStudent: '',
        }
      },
    },

    regionalPitchEventsEnabled: {
      type: Boolean,
      required: false,
      default: false,
    },

    scoresAndCertificatesEnabled: {
      type: Boolean,
      required: false,
      default: false,
    },
  },
}
</script>