<template>
  <div class="tabs tabs--vertical grid" id="admin-content-settings">
    <ul class="tabs__menu grid__col-md-3">
      <router-link
        tag="li"
        class="tabs__menu-link"
        active-class="tabs__menu-link--active"
        :to="{ name: 'registration' }"
      >
        <button role="button" class="tabs__menu-button">
          Registration
        </button>
      </router-link>

      <router-link
        tag="li"
        class="tabs__menu-link"
        active-class="tabs__menu-link--active"
        :to="{ name: 'notices' }"
      >
        <button role="button" class="tabs__menu-button">
          Notices
        </button>
      </router-link>

      <router-link
        tag="li"
        class="tabs__menu-link"
        active-class="tabs__menu-link--active"
        :to="{ name: 'surveys' }"
      >
        <button role="button" class="tabs__menu-button">
          Surveys
        </button>
      </router-link>

      <router-link
        tag="li"
        class="tabs__menu-link"
        active-class="tabs__menu-link--active"
        :to="{ name: 'teams_and_submissions' }"
      >
        <button role="button" class="tabs__menu-button">
          Teams &amp; Submissions
        </button>
      </router-link>

      <router-link
        tag="li"
        class="tabs__menu-link"
        active-class="tabs__menu-link--active"
        :to="{ name: 'events' }"
      >
        <button role="button" class="tabs__menu-button">
          Events
        </button>
      </router-link>

      <router-link
        tag="li"
        class="tabs__menu-link"
        active-class="tabs__menu-link--active"
        :to="{ name: 'judging' }"
      >
        <button role="button" class="tabs__menu-button">
          Judging
        </button>
      </router-link>

      <router-link
        tag="li"
        class="tabs__menu-link"
        active-class="tabs__menu-link--active"
        :to="{ name: 'scores_and_certificates' }"
      >
        <button role="button" class="tabs__menu-button">
          Scores &amp; Certificates
        </button>
      </router-link>
    </ul>

    <router-view class="tabs__content grid__col-md-9"></router-view>
  </div>
</template>

<script>
export default {
  name: 'admin-content-settings',
}
</script>

<style scoped>
</style>