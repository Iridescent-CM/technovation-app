<template>
  <div class="tabs tabs-vertical grid" id="admin-dashboard">
    <ul class="tab-menu grid__col-4">
      <router-link
        tag="li"
        class="tab-link"
        active-class="tabs__menu-link--active"
        :to="{ name: 'students' }"
      >
        <button role="button" class="tab-button">
          Students
        </button>
      </router-link>

      <router-link
        tag="li"
        class="tab-link"
        active-class="tabs__menu-link--active"
        :to="{ name: 'mentors' }"
      >
        <button role="button" class="tab-button">
          Mentors
        </button>
      </router-link>
    </ul>

    <router-view class="content grid__col-8"></router-view>
  </div>
</template>

<script>
export default {
  name: 'admin-dashboard',
}
</script>

<style scoped>
</style>