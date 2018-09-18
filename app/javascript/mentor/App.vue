<template>
  <div>
    <dashboard-header>
      <div slot="survey-links"><slot name="survey-links" /></div>
      <div slot="ra-switch-link"><slot name="ra-switch-link" /></div>
      <div slot="judge-switch-link"><slot name="judge-switch-link" /></div>

      <h6>
        Mentor Training
        <small>
          <a
            href="https://iridescentlearning.atavist.com/technovation-mentor-training"
            target="_blank"
          >Open the Mentor Training E-book</a>
        </small>
      </h6>

      <div slot="ra-intro"><slot name="ra-intro" /></div>
    </dashboard-header>

    <div class="tabs tabs--vertical tabs--css-only tabs--content-first grid">
      <div class="tabs__content background-color--white grid__col-9">
        <router-view :key="$route.name">
          <div slot="change-email"><slot name="change-email" /></div>
          <div slot="change-password"><slot name="change-password" /></div>
          <div slot="bio"><slot name="bio" /></div>
          <div slot="consent-waiver"><slot name="consent-waiver" /></div>
          <div slot="background-check"><slot name="background-check" /></div>
          <div slot="find-team"><slot name="find-team" /></div>
          <div slot="create-team"><slot name="create-team" /></div>
          <div slot="submission"><slot name="submission" /></div>
          <div slot="events"><slot name="events" /></div>
          <div slot="scores"><slot name="scores" /></div>
        </router-view>
        <slot></slot>
      </div>

      <div class="grid__col-3 grid__col--bleed">
        <dashboard-menu />
      </div>
    </div>
  </div>
</template>

<script>
import DashboardMenu from './DashboardMenu'
import DashboardHeader from './DashboardHeader'

export default {
  name: 'app',

  components: {
    DashboardMenu,
    DashboardHeader,
  },
}
</script>

<style scoped lang="scss">
</style>