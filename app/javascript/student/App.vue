<template>
  <div>
    <dashboard-header>
      <div slot="survey-links"><slot name="survey-links" /></div>

      <h6>
        Project Workbook
        <small>
          <a
            href="https://bit.ly/2z7xwP9"
            target="_blank"
          >Open the Student Project Workbook</a>
        </small>
      </h6>

      <div slot="ra-intro"><slot name="ra-intro" /></div>
    </dashboard-header>

    <div class="tabs tabs--vertical tabs--css-only tabs--content-first grid">
      <div class="tabs__content background-color--white grid__col-9">
        <router-view :key="$route.name">
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
        <dashboard-menu />
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
}
</script>