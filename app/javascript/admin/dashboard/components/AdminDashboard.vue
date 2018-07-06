<template>
  <div class="tabs tabs-vertical grid" id="admin-dashboard">
    <ul class="tab-menu grid__col-md-3">
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

    <router-view class="content grid__col-md-9"></router-view>
  </div>
</template>

<script>
export default {
  name: 'admin-dashboard',

  props: {
    chartEndpoints: {
      type: Object,
      default () {
        return {}
      },
    },
  },

  created () {
    this.$store.commit('addChartEndpoints', this.chartEndpoints)
  },
}
</script>

<style scoped>
</style>