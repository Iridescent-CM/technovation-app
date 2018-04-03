<template>
  <nav id="judge-dashboard-scores-nav">
    <router-link
      :to="{ name: 'assigned-submissions' }"
      :class="
        $route.name === 'assigned-submissions' ? 'active' : ''
      "
    >
      Assigned submissions
    </router-link>

    <router-link
      :to="{ name: 'finished-scores' }"
      :class="$route.name === 'finished-scores' ? 'active' : ''"
    >
      Finished scores
    </router-link>
  </nav>
</template>